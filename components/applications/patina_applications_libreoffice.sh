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
# along with this program. If not, see <http://www.gnu.org/licenses/>.

#################
# Documentation #
#################

# Function: 'patina_libreoffice_convert_document'

#   Notes:
#     1. Converts a compatible document to PDF using LibreOffice.

#   Required Packages:
#     1. 'libreoffice' for command 'soffice'.

#   Parameters:
#     1. Filename of compatible document.

#   Example Usage:
#     $ p-pdf "Document.docx"

#############
# Functions #
#############

patina_libreoffice_convert_document() {
  # Failure: Success condition(s) not met.
  if ( ! command -v 'soffice' ) ; then
    patina_throw_exception 'PE0006'
  elif [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
  elif [ "$#" -gt 2 ] ; then
    patina_throw_exception 'PE0002'
  elif [ -d "$1" ] ; then
    patina_throw_exception 'PE0006'

  # Success: Convert an existing document to PDF (if supported).
  elif [ -f "$1" ] ; then
    soffice --convert-to pdf "$1"


  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi
}

###########
# Aliases #
###########

alias 'p-pdf'='patina_libreoffice_convert_document'

# End of File.

