#!/usr/bin/env bash

###########
# LICENSE #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License along with this program. If not,
# see <http://www.gnu.org/licenses/>.

#############
# FUNCTIONS #
#############

# PATINA > FUNCTIONS > APPLICATIONS > GNUPG

patina_gpg() {
  # Success: Display help and exit.
  if [ "$1" == '--help' ] ; then
    echo "Usage: p-gpg [OPTION] [FILE]"
    echo "Usage: p-encrypt [FILE]"
    echo "Usage: p-decrypt [FILE]"
    echo "Encrypt or decrypt a file using GnuPG."
    echo "Dependencies: 'gpg' command from package 'gnupg2'."
    echo
    echo -e "  encrypt\\tCreate a *.gpg encrypted backup of the target file."
    echo -e "  decrypt\\tDecrypt a *.gpg encrypted target file."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0

  # Failure: Patina has not been given an argument.
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 2 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Failure: Patina cannot perform current operation on a directory.
  elif [ -d "$2" ] ; then
    patina_raise_exception 'PE0015'
    return 1

  # Failure: Patina cannot find the file specified.
  elif [ ! -f "$2" ] ; then
    patina_raise_exception 'PE0005'
    return 1

  # Failure: Location is a file without a '.gpg' extension. Do not decrypt file.
  elif [ "$1" == 'decrypt' ] && [ -f "$2" ] && [[ "$2" != *.gpg ]] ; then
    patina_raise_exception 'PE0017'
    return 1

  # Failure: Location is a file with a '.gpg' extension. Do not encrypt file.
  elif [ "$1" == 'encrypt' ] && [ -f "$2" ] && [[ "$2" == *.gpg ]] ; then
    patina_raise_exception 'PE0017'
    return 1

  # Success: Location is a file with a '.gpg' extension. Decrypt file.
  elif [ "$1" == 'decrypt' ] && [ -f "$2" ] && [[ "$2" == *.gpg ]] ; then
    local decrypted_filename
    decrypted_filename="$(printf '%s\n' "${2//.gpg/}")"

    gpg --output "$decrypted_filename" --decrypt "$2"
    return 0

  # Success: Locations is a file. Encrypt file.
  elif [ "$1" == 'encrypt' ] && [ -f "$2" ] && [[ "$2" != *.gpg ]] ; then
    gpg --symmetric "$2"
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# ALIASES #
###########

# PATINA > FUNCTIONS > APPLICATIONS > GNUPG COMMANDS

alias 'p-gpg'='patina_gpg'

# PATINA > FUNCTIONS > APPLICATIONS > GNUPG COMMANDS > SHORTCUTS

alias 'p-decrypt'='p-gpg decrypt'
alias 'p-encrypt'='p-gpg encrypt'

# End of File.
