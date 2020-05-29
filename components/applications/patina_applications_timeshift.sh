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

patina_timeshift() {
  # Success: Display help and exit.
  if [ "$1" = '--help' ] ; then
    echo_wrap "Usage: p-timeshift [OPTION]"
    echo_wrap "Dependencies: 'timeshift' command from package 'timeshift'."
    echo_wrap "Quickly manage system snapshots using Timeshift."
    echo
    echo_wrap "  create\tCreate a Timeshift snapshot with a default label."
    echo_wrap "  restore\tPrompt the user on which snapshot to restore."
    echo_wrap "  --help\tDisplay this help and exit."
    echo
    return

  # Failure: Patina cannot detect a required application.
  elif ( ! command -v 'timeshift' > /dev/null 2>&1 ) ; then
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

  # Success: Create a snapshot of the system and provide a default label.
  elif [ "$1" = 'create' ] ; then
    sudo timeshift --create --yes \
      --comment "System Checkpoint (Patina)." --scripted
    return

  # Success: User will be prompted to restore a specific snapshot.
  elif [ "$1" = 'restore' ] ; then
    sudo timeshift --restore
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

alias 'p-timeshift'='patina_timeshift'

# End of File.
