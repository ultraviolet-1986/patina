#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2019 William Willis Whinn

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

#########################
# ShellCheck Directives #
#########################

#################
# Documentation #
#################

#############
# Variables #
#############

export readonly patina_path_block_storage="$HOME/.patina_blocks"

#############
# Functions #
#############

patina_manage_block_applications() {
  # SECTION / Prerequisites

  # Failure: Package 'genisofs' is not installed.
  if ( ! command -v 'mkisofs' > /dev/null 2>&1 ) ; then
    patina_throw_exception 'PE0006'
  fi

  mkdir -p "$patina_path_block_storage"

  # SECTION / Argument Parsing

  # Failure: No argument was supplied.
  if [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'

  # Failure: Too many arguments supplied.
  elif [ "$#" -gt 3 ] ; then
    patina_throw_exception 'PE0002'

  # Success: Attempt to install a Patina Block Application.
  elif [ "$1" = 'install' ] || [ "$1" = 'refresh' ] ; then
    patina_detect_internet_connection

    # Success: Patina has detected an active Internet connection.
    if [ "$patina_has_internet" = 'true' ] ; then
      echo_wrap "Internet detected. Install a Patina Block application."

      # Success: Download the specified application.
      if [ "$2" = 'code' ] ; then
        patina_block_metadata_code
      elif [ "$2" = 'minecraft' ] ; then
        patina_block_metadata_minecraft
      fi

      # Delete existing Patina Block image.
      if [ -f "$patina_path_block_storage/$patina_block_iso" ] ; then
        rm "$patina_path_block_storage/$patina_block_iso"
      fi

      # Temporarily chand directory to /tmp.
      cd /tmp || return

      # Download the application's tarball to /tmp.
      wget -O "$patina_block_tarball_name" "$patina_block_tarball_url"
      echo

      # Extract the contents of the Tarball.
      # TODO: Detect '.tar', '.tar.gz', '.tar.bz2', etc.
      tar -xvzf "$patina_block_tarball_name"
      echo

      # Convert the raw data into a Patina Block application using 'mkisofs'.
      # Create ISO disk image.
      mkisofs -volid "$patina_block_label" -o "$patina_block_iso" \
        -input-charset UTF-8 -joliet -joliet-long -rock "$patina_block_folder"
      echo

      # Move the Patina Block application to the correct location.
      mv "/tmp/$patina_block_iso" "$patina_path_block_storage/$patina_block_iso"

      # Cleanup temporary files.
      rm -rf "/tmp/$patina_block_folder" "/tmp/$patina_block_tarball_name"

      # Return to original directory.
      cd ~- || return

    # Failure: Patina has not detected an active Internet connection.
    elif [ "$patina_has_internet" = 'false' ] ; then
      patina_throw_exception 'PE0008'
      return
    fi

  elif [ "$1" = 'disconnect' ] || [ "$1" = 'dc' ] ; then
    echo "Disconnect a Patina Block application."

  elif [ "$1" = 'uninstall' ] || [ "$1" = 'remove' ] || [ "$1" = 'rm' ] ; then
    echo_wrap "Uninstall a Patina Block application."

  elif [ "$1" = 'list' ] || [ "$1" = 'ls' ] ; then
    patina_list_block_applications

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi
}

patina_list_block_applications() {
  # Detect all available Patina Block applications.
  for block in "$patina_path_block_storage"/patina_block_*.iso ; do
    if [ -f "$block" ] ; then
      patina_block_list+=("${block}")
    fi
  done

  # List all available Patina Block applications.
  echo_wrap "\\nPatina has detected the following ${#patina_block_list[@]} Block application(s):\\n"
  for block in "${patina_block_list[@]}" ; do
    echo_wrap "$(basename $block)"
  done

  echo
  return
}

# SECTION / Application Metadata

# Microsoft / Visual Studio Code (Stable)
patina_block_metadata_code() {
  patina_block_tarball_url='https://update.code.visualstudio.com/latest/linux-x64/stable'
  patina_block_tarball_name='patina_block_code_tarball.tar.gz'
  patina_block_folder='VSCode-linux-x64'
  patina_block_iso='patina_block_code.iso'
  patina_block_label='p-code'
}

# Mojang / Minecraft
patina_block_metadata_minecraft() {
  patina_block_tarball_url='https://launcher.mojang.com/download/Minecraft.tar.gz'
  patina_block_tarball_name='patina_block_minecraft_tarball.tar.gz'
  patina_block_folder='minecraft-launcher'
  patina_block_iso='patina_block_minecraft.iso'
  patina_block_label='p-minecraft'
}

###########
# Exports #
###########

export -f 'patina_manage_block_applications'

###########
# Aliases #
###########

alias 'p-block'='patina_manage_block_applications'

# End of Files.
