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

# Function: 'generate_volume_label'

#   Notes:
#     1. Generates a 9-digit disk label at random in format 'XXXX-XXXX'.

#   Required Packages:
#     1. 'coreutils' for command 'head'.

#   Parameters:
#     None.

#   Example Usage:
#     $ generate_volume_label

# Function: 'patina_genisoimage_create_iso'

#   Notes:
#     1. Restrictions enabled to enforce ISO-9660 compliance.
#     2. All generated disk images will be stored within user's Home directory.

#   Required Packages:
#     1. 'genisoimage' for command 'mkisofs'.

#   Parameters:
#     1. Name of directory to be converted to an ISO disk image.
#     2. Flag '-f' to bypass ISO-9660 restrictions while creating ISO disk image
#        (optional).

#   Example usage:
#     $ p-iso ~/Documents

#############
# Functions #
#############

generate_volume_label() {
  local label_command="head /dev/urandom | tr -dc A-Za-z0-9 | head -c4 | tr '[:lower:]' '[:upper:]'"
  echo -e "$(eval "$label_command"; printf "-"; eval "$label_command")"
}

patina_genisoimage_create_iso() {
  # Failure: Success condition(s) not met.
  if ( ! hash 'mkisofs' > /dev/null 2>&1 ) ; then
    patina_throw_exception 'PE0006'
  elif [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
  elif [ "$#" -gt 2 ] ; then
    patina_throw_exception 'PE0002'
  elif [ -n "$2" ] && [ "$2" != '-f' ] ; then
    patina_throw_exception 'PE0001'
  elif [ ! -d "$1" ] ; then
    patina_throw_exception 'PE0004'
  elif [ -f "$(basename "$1").iso" ] ; then
    patina_throw_exception 'PE0011'

  # Success: Create ISO Disk Image (ISO-9660 compliant).
  elif [ -d "$1" ] && [ -z "$2" ] ; then
    mkisofs -volid "$(generate_volume_label)" -o "$(basename "$1").iso" -input-charset UTF-8 -joliet -joliet-long -rock "$1"
    return

  # Success: Create ISO Disk Image (Non ISO-9660 compliant).
  elif [ -d "$1" ] && [ "$2" = '-f' ] ; then
    mkisofs -volid "$(generate_volume_label)" -output "$(basename "$1").iso" -input-charset UTF-8 -udf -allow-limited-size -disable-deep-relocation -untranslated-filenames "$1"
    return

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi
}

###########
# Exports #
###########

export -f 'generate_volume_label'

###########
# Aliases #
###########

alias 'p-iso'='patina_genisoimage_create_iso'

# End of File.
