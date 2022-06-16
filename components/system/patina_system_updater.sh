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

patina_update() {
  if ( ! command -v 'git' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 127
  elif ( ! git -C "$PATINA_PATH_ROOT" rev-parse ) ; then
    patina_raise_exception 'PE0009'
    return 1
  elif ( ! patina_detect_internet_connection ) ; then
    patina_raise_exception 'PE0008'
    return 1

  elif ( git -C "${PATINA_PATH_ROOT}" rev-parse ) ; then
    cd "${PATINA_PATH_ROOT}" || return 1
    git pull
    cd ~- || return 1
    return 0

  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Aliases #
###########

alias 'p-update'='patina_update'

# End of File.
