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

patina_timeshift() {
  if [ "$1" = '--help' ] ; then
    echo "Usage: p-timeshift [OPTION]"
    echo "Quickly manage system snapshots using Timeshift."
    echo "Dependencies: 'timeshift' command from package 'timeshift'."
    echo
    echo -e "  create\\tCreate a Timeshift snapshot with a default label."
    echo -e "  restore\\tPrompt the user on which snapshot to restore."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0
  elif ( ! command -v 'timeshift' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    patina_required_software 'timeshift' 'timeshift'
    return 127
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1
  elif [ "$1" = 'create' ] ; then
    sudo timeshift --create --yes --comment "System Checkpoint (Patina)" --scripted
    return 0
  elif [ "$1" = 'restore' ] ; then
    sudo timeshift --restore
    return 0
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Aliases #
###########

alias 'p-timeshift'='patina_timeshift'

# End of File.
