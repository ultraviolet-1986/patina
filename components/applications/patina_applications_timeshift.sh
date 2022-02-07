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

# PATINA > FUNCTIONS > APPLICATIONS > TIMESHIFT

patina_timeshift() {
  # Success: Display help and exit.
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

  # Failure: Patina cannot detect a required application.
  elif ( ! command -v 'timeshift' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    patina_required_software 'timeshift' 'timeshift'
    return 127

  # Failure: Patina has not been given an argument.
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Create a snapshot of the system and provide a default
  # label.
  elif [ "$1" = 'create' ] ; then
    sudo timeshift --create --yes --comment "System Checkpoint (Patina)." --scripted
    return 0

  # Success: User will be prompted to restore a specific snapshot.
  elif [ "$1" = 'restore' ] ; then
    sudo timeshift --restore
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Aliases #
###########

# PATINA > FUNCTIONS > APPLICATIONS > TIMESHIFT COMMANDS

alias 'p-timeshift'='patina_timeshift'

# End of File.
