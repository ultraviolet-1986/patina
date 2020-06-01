#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.

# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with
# this program. If not, see <http://www.gnu.org/licenses/>.

#############
# Functions #
#############

patina_ufw() {
  # Success: Display help and exit.
  if [ "$1" = '--help' ] ; then
    echo_wrap "Usage: p-ufw [OPTION]"
    echo_wrap "Dependencies: 'ufw' command from package 'ufw'."
    echo_wrap "Warning: Command(s) may require 'sudo' password."
    echo_wrap "Configure the 'ufw' firewall."
    echo
    echo_wrap "  disable\tDisable 'ufw'."
    echo_wrap "  enable\tEnable 'ufw'."
    echo_wrap "  setup\t\tEnable 'ufw' with basic rules."
    echo_wrap "  status\tDisplay the status of 'ufw' and list active rules."
    echo_wrap "  --help\tDisplay this help and exit."
    echo
    return

  # Failure: Patina cannot detect a required application.
  elif ( ! command -v 'ufw' > /dev/null 2>&1 ) ; then
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

  # Success: Process argument and apply it to 'ufw'.
  # Warning: Uses 'sudo' to configure 'ufw'.
  elif [ -n "$1" ] ; then
    case "$1" in
      '--disable')
        sudo ufw disable
        return
        ;;
      '--enable')
        sudo ufw enable
        return
        ;;
      '--setup')
        sudo ufw enable
        sudo ufw default deny
        sudo ufw limit ssh
        return
        ;;
      '--status')
        sudo ufw status
        return
        ;;
      *)
        patina_throw_exception 'PE0003'
        return
        ;;
    esac

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

###########
# Aliases #
###########

alias 'p-ufw'='patina_ufw'

# End of File.
