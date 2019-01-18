#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2018 William Willis Whinn

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
  if [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0003'
    return

  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
    return

  elif [ ! -f "$1" ] ; then
    patina_throw_exception 'PE0005'
    return

  elif [ -f "$1" ] ; then
    local decrypted_filename
    decrypted_filename="$(printf '%s\n' "${1//.gpg/}")"

    gpg --output "$decrypted_filename" --decrypt "$1"

    # Ask user to delete encrypted file.
    printf "Do you wish to remove the encrypted file [Y/N]? "
    read -n1 -r answer
    case "$answer" in
      'Y'|'y') rm "$1" ; echo ;;
      'N'|'n') echo ; return ;;
      *) patina_throw_exception 'PE0003' ; return ;;
    esac
  fi
}

patina_gpg_encrypt_file() {
  if [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0003'
    return

  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
    return

  elif [ ! -f "$1" ] ; then
    patina_throw_exception 'PE0005'
    return

  elif [ -f "$1" ] ; then
    gpg --symmetric "$1"

    # Ask user to delete original file.
    printf "Do you wish to remove the original file [Y/N]? "
    read -n1 -r answer
    case "$answer" in
      'Y'|'y') rm "$1" ; echo ;;
      'N'|'n') echo ; return ;;
      *) patina_throw_exception 'PE0003' ; return ;;
    esac
  fi
}

###########
# Aliases #
###########

alias 'p-decrypt'='patina_gpg_decrypt_file'
alias 'p-encrypt'='patina_gpg_encrypt_file'

# End of File.
