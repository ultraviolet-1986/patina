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

#################
# Documentation #
#################

# Function: 'patina_genisoimage_create_iso'

#   Notes:
#     1. Function will generate an *.iso file which is not ISO-9660 compliant.
#     2. All generated disk images will be stored within user's Home directory.

#   Required Packages:
#     1. 'genisoimage' for command 'mkisofs'.

#   Parameters:
#     1. Name of directory to be converted to an ISO disk image.

#   Example usage:
#     $ p-iso ~/Documents

#############
# Functions #
#############

patina_genisoimage_create_iso() {
  # Failure: Success condition(s) not met.
  if [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
  elif [ ! -d "$1" ] ; then
    patina_throw_exception 'PE0004'
  elif [ -f "$HOME/$(basename "$1").iso" ] ; then
    patina_throw_exception 'PE0011'
  elif ( ! hash 'mkisofs' > /dev/null 2>&1 ) ; then
    patina_throw_exception 'PE0006'

  # Success: Create ISO Disk Image.
  elif [ -d "$1" ] ; then
    mkisofs -volid "$(generate_date_stamp)" -o "$HOME/$(basename "$1").iso" -U -R -D "$1"
    sync
    return

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi
}

###########
# Aliases #
###########

alias 'p-iso'='patina_genisoimage_create_iso'

# End of File.
