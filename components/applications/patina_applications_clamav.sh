#!/usr/bin/env bash

###########
# LICENSE #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License along with this program. If not,
# see <http://www.gnu.org/licenses/>.

#############
# FUNCTIONS #
#############

# PATINA > FUNCTIONS > APPLICATIONS > CLAMAV/FRESHCLAM

patina_clamav() {
  local patina_create_clamav_logfile
  local patina_clamav_logfile

  local clamav_path
  clamav_path='/var/lib/clamav'

  # Success: Display contents of help file.
  if [ "$1" = '--help' ] ; then
    echo -e "Usage: p-clamscan [FILE/DIRECTORY] [OPTION]"
    echo -e "Dependencies: 'clamscan' command from package 'clamav'."
    echo -e "Dependencies: 'freshclam' command from package 'clamav'/'clamav-update'."
    echo -e "Warning: Command(s) may require 'sudo' password."
    echo -e "Perform a recursive virus scan of a given location and record results."
    echo
    echo -e "  --repair\tPurge and replace current virus database."
    echo -e "  --help\tDisplay this help and exit."
    echo
    return 0

  # Failure: Command 'clamscan' is not available.
  elif ( ! command -v 'clamscan' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 127

  # Failure: Command 'freshclam' is not available.
  elif ( ! command -v 'freshclam' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 127

  # Failure: Patina has not been given an argument.
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    echo
    patina_clamav --help
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Repair Freshclam update mechanism.
  # Warning: Uses 'sudo' to delete system files and execute Freshclam update program.
  elif [ "$1" = '--repair' ] ; then
    printf "${YELLOW}This command requires root permissions. Continue [Y/N]?${COLOR_RESET} "
    read -n1 -r answer
    echo

    case "$answer" in
      'Y'|'y')
        sudo rm --force \
          "$clamav_path/bytecode.cvd" \
          "$clamav_path/daily.cld" \
          "$clamav_path/main.cvd" \
          "$clamav_path/mirrors.dat" && \
        sudo freshclam
        return 0
        ;;
      'N'|'n')
        return 0
        ;;
      *)
        patina_raise_exception 'PE0003'
        return 1
        ;;
    esac

  # Failure: Scan target does not exist.
  elif [[ ! -e "$1" ]] ; then
    patina_raise_exception 'PE0016'
    return 1

  # Success: Guide user in performing virus scan.
  elif [ "$#" -ne 0 ] && [[ -e "$1" ]] ; then
    echo
    printf "${YELLOW}Do you wish to record a log file in your Home directory [Y/N]?${COLOR_RESET} "
    read -n1 -r answer
    echo

    case "$answer" in
      'Y'|'y')
        patina_create_clamav_logfile='true'
        patina_clamav_logfile="clamscan_log_$(generate_date_stamp).txt"
        ;;
      'N'|'n')
        patina_create_clamav_logfile='false'
        ;;
      *)
        patina_raise_exception 'PE0003'
        return 1
        ;;
    esac

    echo -e "\\n\\nPreparing 'clamav' virus scan, please wait...\\n"

    case "$patina_create_clamav_logfile" in
      true)
        clamscan -l ~/"$patina_clamav_logfile" -r "$1" -v
        echo
        return 0
        ;;
      false)
        clamscan -r "$1" -v
        echo
        return 0
        ;;
      *)
        patina_raise_exception 'PE0003'
        return 1
        ;;
    esac

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# ALIASES #
###########

# PATINA > FUNCTIONS > APPLICATIONS > CLAMAV/FRESHCLAM

alias 'p-clamscan'='patina_clamav'

# End of File.
