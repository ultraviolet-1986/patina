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

patina_gpg_decrypt_file() {
  # Failure: Success condition(s) not met.
  if [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0003'
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
  elif [ ! -f "$1" ] ; then
    patina_throw_exception 'PE0005'

  # Success: Decrypt the GnuPG encrypted file.
  elif [ -f "$1" ] ; then
    local decrypted_filename
    decrypted_filename="$(printf '%s\n' "${1//.gpg/}")"
    gpg --output "$decrypted_filename" --decrypt "$1"
    return

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi
}

patina_gpg_encrypt_file() {
  # Failure: Success condition(s) not met.
  if [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0003'
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
  elif [ ! -f "$1" ] ; then
    patina_throw_exception 'PE0005'

  # Success: Encrypt the file using GnuPG symmetric encryption.
  elif [ -f "$1" ] ; then
    gpg --symmetric "$1"
    return

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi
}

###########
# Aliases #
###########

alias 'p-decrypt'='patina_gpg_decrypt_file'
alias 'p-encrypt'='patina_gpg_encrypt_file'

# End of File.
