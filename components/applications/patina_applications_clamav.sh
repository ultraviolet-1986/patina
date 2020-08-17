#!/usr/bin/env bash

###########
# License #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

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

#############
# Functions #
#############

# PATINA > FUNCTIONS > APPLICATIONS > CLAMAV

patina_clamav() {
  local patina_create_clamav_logfile
  local patina_clamav_logfile

  local clamav_path
  clamav_path='/var/lib/clamav'

  # Success: Display contents of help file.
  if [ "$1" = '--help' ] ; then
    echo "Usage: p-clamscan [FILE/DIRECTORY] [OPTION]"
    echo "Perform a recursive virus scan of a given location and record results."
    echo "Dependencies: 'clamscan' command from package 'clamav'."
    echo "Warning: Command(s) may require 'sudo' password."
    echo
    echo -e "  --repair\\tPurge and replace current virus database."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0

  # Failure: Command 'clamscan' is not available.
  elif ( ! command -v 'clamscan' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 127

  # Failure: Patina has not been given an argument.
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Repair Freshclam update mechanism.
  # Warning: Uses 'sudo' to delete system files and execute Freshclam
  # update program.
  elif [ "$1" = '--repair' ] ; then
    printf "%bNOTE:%b This command requires root permissions. Continue [Y/N]? " \
      "${BOLD}" "${COLOR_RESET}"
    read -n1 -r answer
    echo

    case "$answer" in
      'Y'|'y')
        # Failure: Patina cannot download updated Database files from
        # ClamAV mirror.
        if ( ! patina_detect_internet_connection ) ; then
          patina_raise_exception 'PE0008'
          return 1

        # Success: Delete old ClamAV database files and download new
        # ones from ClamAV mirror.
        elif ( patina_detect_internet_connection ) ; then
          local clamav_mirror='http://database.clamav.net'

          sudo rm --force \
            "$clamav_path/bytecode.cvd" \
            "$clamav_path/daily.cld" \
            "$clamav_path/main.cvd"

          printf "\\n%bNOTE:%b Downloading 'bytecode.cvd' from '${clamav_mirror}'...\\n" \
            "${BOLD}" "${COLOR_RESET}"
          sudo curl "$clamav_mirror/bytecode.cvd" --output "$clamav_path/bytecode.cvd"

          printf "\\n%bNOTE:%b Downloading 'daily.cvd' from '${clamav_mirror}'...\\n" \
            "${BOLD}" "${COLOR_RESET}"
          sudo curl "$clamav_mirror/daily.cvd" --output "$clamav_path/daily.cvd"

          printf "\\n%bNOTE:%b Downloading 'main.cvd' from '${clamav_mirror}'...\\n" \
            "${BOLD}" "${COLOR_RESET}"
          sudo curl "$clamav_mirror/main.cvd" --output "$clamav_path/main.cvd"
          echo

          return 0

        # Failure: Catch all.
        else
          patina_raise_exception 'PE0000'
          return 1
        fi
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
    printf "Do you wish to record a log file in your Home directory [Y/N]? "
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

    echo -e "\\nPreparing 'clamav' virus scan, please wait...\\n"

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
# Aliases #
###########

# PATINA > FUNCTIONS > APPLICATIONS > CLAMAV COMMANDS

alias 'p-clamscan'='patina_clamav'

# End of File.
