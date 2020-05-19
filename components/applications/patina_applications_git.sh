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

patina_git() {
  # Failure: Patina has not been given an argument
  if [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
    return

  # Failure: Patina has been given multiple arguments
  elif [ "$#" -gt "1" ] ; then
    patina_throw_exception 'PE0002'
    return

  # Failure: Patina cannot detect a required application
  elif ( ! command -v 'git' > /dev/null 2>&1 ) ; then
    patina_throw_exception 'PE0006'

  # Success: Parse 'git' arguments
  elif [ "$1" = 'undo' ] ; then
    git reset --hard HEAD

  # Failure: Catch any other error condition here
  else
    patina_throw_exception 'PE0003'
    return
  fi
}

###########
# Aliases #
###########

alias 'p-git'='patina_git'

# End of File.
