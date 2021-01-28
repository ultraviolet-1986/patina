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

##############
# References #
##############

# - Recursive Checksum Scanning
#   https://tinyurl.com/patina-system-checksum-001

#############
# Functions #
#############

# PATINA > FUNCTIONS > SYSTEM > CHECKSUM

patina_checksum_recursive() {
  # Success: Display help and exit.
  if [ "$1" = '--help' ] ; then
    echo "Usage: p-hash [OPTION] [DIRECTORY]"
    echo "Recursively hash directory contents and record results to a file."
    echo "Dependencies: Package 'coreutils'."
    echo "Note: Shortcuts exist: e.g.: 'p-md5sum', 'p-sha512sum', etc..."
    echo
    echo -e "  b2sum\\t\\tRecursively hash directory contents using BLAKE2 algorithm."
    echo -e "  md5sum\\tRecursively hash directory contents using MD5 algorithm."
    echo -e "  sha1sum\\tRecursively hash directory contents using SHA1 algorithm."
    echo -e "  sha224sum\\tRecursively hash directory contents using SHA224 algorithm."
    echo -e "  sha256sum\\tRecursively hash directory contents using SHA256 algorithm."
    echo -e "  sha384sum\\tRecursively hash directory contents using SHA384 algorithm."
    echo -e "  sha512sum\\tRecursively hash directory contents using SHA512 algorithm."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0

  # Failure: Command for the hasing algorithm is not available.
  elif ( ! command -v "$1" > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 127

  # Failure: Patina has not been given the correct number of arguments.
  elif [ "$#" -lt 2 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 2 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Parse all files recursively using the selected hashing
  # algorithm.
  elif [ "$#" -eq 2 ] && [ -d "$2" ] ; then
    rm --force "${PWD##*/}.$1"
    shopt -s globstar dotglob
    for file in "$2"/**; do
      [[ -f "$file" ]] && [[ "${PWD##*/}.$1" != "$file" ]] &&
        "$1" "$file" | tee --append "${PWD##*/}.$1"
    done
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Exports #
###########

# PATINA > FUNCTIONS > SYSTEM > CHECKSUM

export -f 'patina_checksum_recursive'

###########
# Aliases #
###########

# PATINA > FUNCTIONS > SYSTEM > CHECKSUM COMMANDS

alias 'p-hash'='patina_checksum_recursive'

alias 'p-b2sum'="patina_checksum_recursive 'b2sum'"
alias 'p-md5sum'="patina_checksum_recursive 'md5sum'"
alias 'p-sha1sum'="patina_checksum_recursive 'sha1sum'"
alias 'p-sha224sum'="patina_checksum_recursive 'sha224sum'"
alias 'p-sha256sum'="patina_checksum_recursive 'sha256sum'"
alias 'p-sha384sum'="patina_checksum_recursive 'sha384sum'"
alias 'p-sha512sum'="patina_checksum_recursive 'sha512sum'"

# End of File.
