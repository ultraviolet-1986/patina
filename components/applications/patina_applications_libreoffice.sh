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

patina_libreoffice() {
  if [ "$1" = '--help' ] ; then
    echo "Usage: p-pdf [FILE]"
    echo "Convert a supported file to *.pdf format."
    echo "Dependencies: 'soffice' command from package 'libreoffice'."
    echo
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0
  elif ( ! command -v 'soffice' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    patina_required_software 'soffice' 'libreoffice'
    return 127
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1
  elif [ "$#" -gt 2 ] ; then
    patina_raise_exception 'PE0002'
    return 1
  elif [ -d "$1" ] ; then
    patina_raise_exception 'PE0015'
    return 1
  elif [ -f "$1" ] ; then
    soffice --convert-to pdf "$1"
    return 0
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Aliases #
###########

alias 'p-pdf'='patina_libreoffice'

# End of File.
