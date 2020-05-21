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

patina_libreoffice() {
  # Success: Display help and exit.
  if [ "$1" = '--help' ] ; then
    echo_wrap "Usage: p-pdf [FILE] [OPTION]"
    echo_wrap "Dependencies: 'soffice' command from package 'libreoffice'."
    echo_wrap "Convert a supported file to *.pdf format."
    echo
    echo_wrap "  --help\tDisplay this help and exit"
    return

  # Failure: Patina cannot detect a required application.
  elif ( ! command -v 'soffice' > /dev/null 2>&1 ) ; then
    patina_throw_exception 'PE0006'
    return

  # Failure: Patina has not been given an argument.
  elif [ "$#" -eq 0 ] ; then
    patina_throw_exception 'PE0001'
    return

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 2 ] ; then
    patina_throw_exception 'PE0002'
    return

  # Failure: Patina cannot convert a directory to PDF.
  elif [ -d "$1" ] ; then
    patina_throw_exception 'PE0015'
    return

  # Success: Convert an existing document to PDF (if supported).
  elif [ -f "$1" ] ; then
    soffice --convert-to pdf "$1"
    return

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

###########
# Aliases #
###########

alias 'p-pdf'='patina_libreoffice'

# End of File.

