#!/usr/bin/env bash

###########
# License #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2021 William Willis Whinn

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

##############
# References #
##############

# Fedora Magazine / Backup and restore Toolboxes
# - https://tinyurl.com/tru8y8jz

#############
# Functions #
#############

# PATINA > FUNCTIONS > APPLICATIONS > TOOLBOX

patina_toolbox(){
  local datestamp
  datestamp="$(date --utc +%Y%m%d_%H%M%S)"

  # Success: Display contents of help file.
  if [ "$1" = '--help' ] ; then
    echo "Usage: p-toolbox [OPTION] [CONTAINER/IMAGE/ARCHIVE]"
    echo "Easily manage 'toolbox' containers."
    echo "Dependencies: 'toolbox' command from package 'toolbox'."
    echo "              'podman' command from package 'podman'."
    echo
    echo -e "  commit\\tCreate an image from a given container."
    echo -e "  export\\tExport a given container to an archive."
    echo -e "  import\\tImport a given archive to an image."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0

  # Failure: Command 'toolbox' is not available.
  elif ( ! command -v 'toolbox' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 127

  # Failure: Command 'podman' is not available.
  elif ( ! command -v 'podman' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 127

  # Failure: Patina has not been given an argument.
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 2 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Failure: A container name was not provided.
  elif [ -z "$2" ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Success: Commit a container to a date-stamped image.
  elif [ "$1" = 'commit' ] ; then
    local image_name="$2_${datestamp}"
    local container="${YELLOW}${2}${COLOR_RESET}"
    local image="${YELLOW}${image_name}${COLOR_RESET}"

    echo -e "Now committing container ${container} to image ${image}. Please wait."
    podman container commit -p "$2" "${image_name}" || return 1

    return 0

  # Success: Export a given image to an archive.
  elif [ "$1" = 'export' ] ; then
    local image="${YELLOW}${2}${COLOR_RESET}"
    local file="${YELLOW}${2}.tar${COLOR_RESET}"

    echo -e "Now exporting image ${image} to file ${file}. Please wait."
    podman save -o "$2.tar" "$2" || return 1

    return 0

  # Success: Import a given archive to an image.
  elif [ "$1" = 'import' ] && [ -f "$2" ] ; then
    local file="${YELLOW}${2}${COLOR_RESET}"
    local image
    image="${YELLOW}$(basename "$2" .tar)${COLOR_RESET}"

    # Success: A supported file type was provided.
    if [ "${2: -4}" == ".tar" ] ; then
      echo -e "Now importing archive ${file} to image ${image}. Please wait."
      podman load -i "$2" || return 1

      return 0

    # Failure: An unsupported file type was specified.
    else
      patina_raise_exception 'PE0017'
      return 1
    fi

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Exports #
###########

# PATINA > FUNCTIONS > APPLICATIONS > TOOLBOX

export -f 'patina_toolbox'

###########
# Aliases #
###########

# PATINA > FUNCTIONS > APPLICATIONS > TOOLBOX COMMANDS

alias 'p-toolbox'="patina_toolbox"

# End of File.
