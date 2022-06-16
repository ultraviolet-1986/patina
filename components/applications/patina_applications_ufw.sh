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

patina_ufw() {
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
  elif ( ! command -v 'ufw' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    patina_required_software 'ufw' 'ufw'
    return 127
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

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
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Aliases #
###########

alias 'p-ufw'='patina_ufw'

# End of File.
