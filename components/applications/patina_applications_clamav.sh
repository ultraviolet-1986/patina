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

#############
# Functions #
#############

patina_clamav_scan() {
  local patina_create_clamav_logfile=''
  local patina_clamav_logfile=''

  # Failure: Success condition(s) not met.
  if ( ! command -v 'clamscan' > /dev/null 2>&1 ) ; then
    patina_throw_exception 'PE0006'
    return

  # Failure: Patina has not been given an argument.
  elif [ "$#" -eq 0 ] ; then
    patina_throw_exception 'PE0001'
    return

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
    return

  # Success: Display contents of help file.
  elif [ "$1" = '--help' ] ; then
    echo_wrap "Usage: p-clamscan [FILE/DIRECTORY] [OPTION]"
    echo_wrap "Dependencies: 'clamscan' command from package 'clamav'."
    echo_wrap "Perform a recursive virus scan of a given location and record results."
    echo
    echo_wrap "  --repair\tPurge and replace current virus database"
    echo_wrap "  --help\tDisplay this help and exit"
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
    patina_throw_exception 'PE0016'
    return

  # Success: Guide user in performing virus scan.
  elif [ "$#" -ne 0 ] && [[ -e "$1" ]] ; then
    echo
    printf "Do you wish to record a log file in your home directory [Y/N]? "
    read -n1 -r answer

    case "$answer" in
      'Y'|'y') patina_create_clamav_logfile='true' ;;
      'N'|'n') patina_create_clamav_logfile='false' ;;
      *) patina_throw_exception 'PE0003' ;;
    esac

    patina_clamav_logfile="clamscan_log_$(generate_date_stamp).txt"

    echo -e "\\n"

    echo_wrap "Preparing 'clamav' virus scan, please wait...\\n"

    case "$patina_create_clamav_logfile" in
      true) clamscan -l ~/"$patina_clamav_logfile" -r "$1" -v ;;
      false) clamscan -r "$1" -v ;;
      *) patina_throw_exception 'PE0003'; return ;;
    esac

    echo
    return

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

###########
# Aliases #
###########

alias 'p-clamscan'='patina_clamav_scan'

# End of File.
