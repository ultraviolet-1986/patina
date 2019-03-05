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
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#############
# Functions #
#############

# Requires: Package 'xorriso', 'genisoimage' will not perform operation.
patina_create_iso() {
  if [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
    return
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
    return
  elif ( ! hash 'xorriso' > /dev/null 2>&1 ) ; then
    patina_throw_exception 'PE0006'
    return
  elif [ -d "$1" ] ; then
    # Success: Create ISO file and a SHA-512 checksum file.
    mkisofs -l -J -V "$1" -r "$1" -o "$1".iso
    sync
    sha512sum "$1".iso | tee "$1".sha512sum
    echo
    return
  elif [ ! -d "$1" ] ; then
    patina_throw_exception 'PE0004'
    return
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

###########
# Aliases #
###########

alias 'p-iso'='patina_create_iso'

# End of File.
