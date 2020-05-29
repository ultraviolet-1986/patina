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

patina_gpg() {
  # Success: Display help and exit.
  if [ "$1" == '--help' ] ; then
    echo_wrap "Usage: p-gpg [OPTION] [FILE]"
    echo_wrap "Usage: p-encrypt [FILE]"
    echo_wrap "Usage: p-decrypt [FILE]"
    echo_wrap "Dependencies: 'gpg' command from package 'gnupg2'."
    echo_wrap "Manage file encryption using GnuPG."
    echo
    echo_wrap "  encrypt\tCreate a *.gpg encrypted backup of the target file."
    echo_wrap "  decrypt\tDecrypt a *.gpg encrypted target file."
    echo_wrap "  --help\tDisplay this help and exit."
    return

  # Failure: Patina has not been given an argument.
  elif [ "$#" -eq 0 ] ; then
    patina_throw_exception 'PE0001'
    return

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 2 ] ; then
    patina_throw_exception 'PE0002'
    return

  # Failure: Patina cannot perform current operation on a directory.
  elif [ -d "$2" ] ; then
    patina_throw_exception 'PE0015'
    return

  # Failure: Patina cannot find the file specified.
  elif [ ! -f "$2" ] ; then
    patina_throw_exception 'PE0005'
    return

  # Success: Use GnuPG to manage file.
  elif [ -f "$2" ] ; then
    case "$1" in
      'decrypt')
        local decrypted_filename
        decrypted_filename="$(printf '%s\n' "${2//.gpg/}")"

        gpg --output "$decrypted_filename" --decrypt "$2"
        return
        ;;
      'encrypt')
        gpg --symmetric "$2"
        return
        ;;
      *)
        patina_throw_exception 'PE0000'
        return
        ;;
    esac

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

###########
# Aliases #
###########

# Main Command(s).
alias 'p-gpg'='patina_gpg'

# Shortcut Command(s).
alias 'p-decrypt'='p-gpg decrypt'
alias 'p-encrypt'='p-gpg encrypt'

# End of File.
