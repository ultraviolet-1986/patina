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
# along with this program. If not, see <http:#www.gnu.org/licenses/>.

#############
# Functions #
#############

# PATINA > FUNCTIONS > APPLICATIONS > UFW

patina_ufw() {
  # Success: Display help and exit.
  if [ "$1" = '--help' ] ; then
    echo "Usage: p-ufw [OPTION]"
    echo "Configure the 'ufw' firewall."
    echo "Warning: Command(s) require 'sudo' password."
    echo "Dependencies: 'ufw' command from package 'ufw'."
    echo
    echo -e "  disable\\tDisable 'ufw'."
    echo -e "  enable\\tEnable 'ufw'."
    echo -e "  setup\\t\\tEnable 'ufw' with basic rules."
    echo -e "  status\\tDisplay the status of 'ufw' and list active rules."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0

  # Failure: Patina cannot detect a required application.
  elif ( ! command -v 'ufw' > /dev/null 2>&1 ) ; then
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

  # Success: Process argument and apply it to 'ufw'.
  # Warning: Uses 'sudo' to configure 'ufw'.
  elif [ -n "$1" ] ; then
    case "$1" in
      'disable')
        sudo ufw disable
        return 0
        ;;
      'enable')
        sudo ufw enable
        return 0
        ;;
      'setup')
        sudo ufw enable
        sudo ufw default deny
        sudo ufw limit ssh
        return 0
        ;;
      'status')
        sudo ufw status
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

# PATINA > FUNCTIONS > APPLICATIONS > UFW COMMANDS

alias 'p-ufw'='patina_ufw'

# End of File.
