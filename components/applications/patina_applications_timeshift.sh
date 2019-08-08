#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2019 William Willis Whinn

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

#################
# Documentation #
#################

# Function: 'patina_timeshift'

#   Required Packages:
#     1. 'timeshift' for command 'timeshift'.

#   Parameters:
#     1. Argument of 'create' or 'restore' to create a timeshift snapshot or
#        restore system as required.

#   Example usage:
#     $ p-timeshift create
#     $ p-timeshift restore

#############
# Functions #
#############

patina_timeshift() {
  # Failure: Success condition(s) not met.
  if ( ! command -v 'timeshift' ) ; then
    patina_throw_exception 'PE0006'
  elif [ "$#" -eq 0 ] ; then
    patina_throw_exception 'PE0001'
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'

  # Success: Snapshot or restore system using Timeshift (if installed).
  elif [ "$1" = 'create' ] ; then
    sudo timeshift --create --yes --comment "System Checkpoint (Patina)." --scripted
  elif [ "$1" = 'restore' ] ; then
    sudo timeshift --restore

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi
}

###########
# Aliases #
###########

alias 'p-timeshift'='patina_timeshift'

# End of File.
