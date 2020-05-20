#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

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

#################
# Documentation #
#################

# Function: 'patina_clamav_scan'

#   Required Packages:
#     1. 'clamav' for command 'clamscan'.

#   Parameters:
#     1. Name of file/directory to be recursively scanned using ClamAV.

#   Example usage:
#     $ p-clamscan ~/Documents
#     $ p-clamscan --help
#     $ p-clamscan --repair

#########################
# ShellCheck Directives #
#########################

# Override SC2154: "var is referenced but not assigned".
# shellcheck disable=SC2154

#############
# Variables #
#############

readonly patina_file_clamav_help="$patina_path_resources_help/patina_applications_clamav_help.txt"

#############
# Functions #
#############

patina_clamav_scan() {
  local patina_create_clamav_logfile=''
  local patina_clamav_logfile=''

  # Failure: Success condition(s) not met.
  if ( ! command -v 'clamscan' > /dev/null 2>&1 ) ; then
    patina_throw_exception 'PE0006'
  elif [ "$#" -eq 0 ] ; then
    patina_throw_exception 'PE0001'
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'

  # Success: Display contents of help file.
  elif [ "$1" = '--help' ] ; then
    patina_clamav_help
    return

  # Success: Repair Freshclam update mechanism.
  # Warning: Uses 'sudo' to delete system files.
  elif [ "$1" = '--repair' ] ; then
    local clamav_path='/var/lib/clamav'
    cd "$clamav_path" || exit
    sudo rm bytecode.cvd daily.cld main.cvd mirrors.dat
    cd ~- || exit
    return

  # Failure: Scan target does not exist.
  elif [[ ! -e "$1" ]] ; then
    patina_throw_exception 'PE0004'

  # Success: Guide user in performing virus scan.
  elif [ "$#" -ne 0 ] && [[ -e "$1" ]] ; then
    echo
    printf "Do you wish to record a log file in your home directory [Y/N]? "
    read -n1 -r answer

    case "$answer" in
      'Y' | 'y')
        patina_create_clamav_logfile='true'
        ;;
      'N' | 'n')
        patina_create_clamav_logfile='false'
        ;;
      *)
        patina_throw_exception 'PE0003'
        ;;
    esac

    patina_clamav_logfile="clamscan_log_$(generate_date_stamp).txt"

    echo -e "\\n"

    # tput civis
    echo_wrap "Preparing 'clamav' virus scan, please wait...\\n"

    case "$patina_create_clamav_logfile" in
      true) clamscan -l ~/"$patina_clamav_logfile" -r "$1" -v ;;
      false) clamscan -r "$1" -v ;;
      *) patina_throw_exception 'PE0003'; return ;;
    esac

    # tput cnorm
    echo

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi
}

patina_clamav_help() {
  clear
  echo_wrap "${underline}${patina_major_color}Patina / ClamAV Instructions${color_reset}\\n"
  echo_wrap "$(cat "${patina_file_clamav_help}")\\n"
}

###########
# Aliases #
###########

alias 'p-clamscan'='patina_clamav_scan'

# End of File.
