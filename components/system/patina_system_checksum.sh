#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.

# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with
# this program. If not, see <http://www.gnu.org/licenses/>.

#############
# Functions #
#############

patina_checksum_recursive() {
  # Failure: Command for the hasing algorithm is not available.
  if ( ! command -v "$1" > /dev/null 2>&1 ) ; then
    patina_throw_exception 'PE0006'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -ge 2 ] ; then
    patina_throw_exception 'PE0002'
    return 1

  # Success: Parse all files recursively using the selected hashing algorithm.
  elif [ "$#" -eq 1 ] ; then
    shopt -s globstar dotglob
    "$1" ./** > "${PWD##*/}.$1"
    return 0

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
    return 1
  fi
}

###########
# Exports #
###########

export -f 'patina_checksum_recursive'

###########
# Aliases #
###########

alias 'p-b2sum'="patina_checksum_recursive 'b2sum'"
alias 'p-md5sum'="patina_checksum_recursive 'md5sum'"
alias 'p-sha1sum'="patina_checksum_recursive 'sha1sum'"
alias 'p-sha224sum'="patina_checksum_recursive 'sha224sum'"
alias 'p-sha256sum'="patina_checksum_recursive 'sha256sum'"
alias 'p-sha384sum'="patina_checksum_recursive 'sha384sum'"
alias 'p-sha512sum'="patina_checksum_recursive 'sha512sum'"

# End of File.
