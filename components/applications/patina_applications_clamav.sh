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
    echo -e "  --parse\\tScan log file and show a list of infections."
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

  # Success: Parse log file and show a list of infections.
  elif [ "$1" = '--parse' ] ; then
    # ShellCheck SC2002: Useless cat.
    # shellcheck disable=SC2002

    for f in clamscan_log*.txt ; do
      if [ -f "$f" ] ; then
        echo -e "\\nScanning ${PATINA_MAJOR_COLOR}$f${COLOR_RESET}..."
        echo
        cat "$f" | grep FOUND || echo -e \
          "${GREEN}SUCCESS: No infections found in ClamAV logfile.${COLOR_RESET}"
        echo
        return 0

      else
        patina_raise_exception "PE0005"
        return 1
      fi
    done

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
