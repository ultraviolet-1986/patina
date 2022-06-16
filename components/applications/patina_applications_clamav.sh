#!/usr/bin/env bash

###########
# License #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2022 William Willis Whinn

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

patina_clamav() {
  local patina_create_clamav_logfile
  local patina_clamav_logfile

  if [ "$1" = '--help' ] ; then
    echo "Usage: p-clamscan [FILE/DIRECTORY] [OPTION]"
    echo "Perform a recursive virus scan of a given location and record results."
    echo "Dependencies: 'clamscan' command from package 'clamav'."
    echo
    echo -e "  --parse\\tScan log file and show a list of infections."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0
  elif ( ! command -v 'clamscan' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    patina_required_software 'clamscan' 'clamav'
    return 127
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1
  elif [ "$1" = '--parse' ] ; then
    for f in clamscan_log*.txt ; do
      if [ -f "$f" ] ; then
        echo -e "\\nScanning ${PATINA_MAJOR_COLOR}$f${COLOR_RESET}..."
        echo
        grep FOUND "$f" || echo -e \
          "${GREEN}SUCCESS: No infections found in ClamAV logfile.${COLOR_RESET}"
        echo
        return 0

      else
        patina_raise_exception "PE0005"
        return 1
      fi
    done
  elif [[ ! -e "$1" ]] ; then
    patina_raise_exception 'PE0016'
    return 1
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
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Aliases #
###########

alias 'p-clamscan'='patina_clamav'

# End of File.
