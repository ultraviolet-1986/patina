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

# PATINA > FUNCTIONS > APPLICATIONS > GIT

patina_git() {
  # Success: Display help and exit.
  if [ "$1" = '--help' ] ; then
    echo "Usage: p-git [OPTION]"
    echo "Perform git operations within the current directory."
    echo "Dependencies: 'git' command from package 'git'."
    echo
    echo -e "  undo\\t\\tDiscard changes to repository since previous commit."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0

  # Failure: Patina cannot detect a required application.
  elif ( ! command -v 'git' > /dev/null 2>&1 ) ; then
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

  # Success: Parse 'git' arguments.
  elif [ "$1" = 'undo' ] ; then
    git reset --hard HEAD
    return 0

  # Failure: An invalid argument was provided.
  else
    patina_raise_exception 'PE0003'
    return 1
  fi
}

###########
# Aliases #
###########

# PATINA > FUNCTIONS > APPLICATIONS > GIT COMMANDS

alias 'p-git'='patina_git'

# End of File.
