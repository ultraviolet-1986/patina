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

#########################
# ShellCheck Directives #
#########################

# Override SC2154: "var is referenced but not assigned".
# shellcheck disable=SC2154

#############
# Functions #
#############

# PATINA > FUNCTIONS > SYSTEM > PATINA UPDATER

patina_update() {
  # Failure: Package 'git' is not installed.
  if ( ! command -v 'git' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 127

  # Failure: Patina root is not a 'git' repository.
  elif ( ! git -C "$PATINA_PATH_ROOT" rev-parse ) ; then
    patina_raise_exception 'PE0009'
    return 1

  # Failure: Patina is not connected to the Internet.
  elif ( ! patina_detect_internet_connection ) ; then
    patina_raise_exception 'PE0008'
    return 1

  # Success: Patina will check for newer 'git' commits.
  elif ( git -C "$PATINA_PATH_ROOT" rev-parse ) ; then
    cd "$PATINA_PATH_ROOT" || return 1
    git pull
    cd ~- || return 1
    return 0

  # Failure: Catch any other error condition here.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Aliases #
###########

# PATINA > FUNCTIONS > SYSTEM > PATINA UPDATER COMMANDS

alias 'p-update'='patina_update'

# End of File.
