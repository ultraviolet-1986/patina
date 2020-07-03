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

patina_genisoimage() {
  # Success: Display help and exit.
  if [ "$1" = '--help' ] ; then
    echo_wrap "Usage: p-iso [DIRECTORY] [OPTION]"
    echo_wrap "Dependencies: 'mkisofs' command from package 'genisoimage'."
    echo_wrap "Create a read-only disk image in .iso format."
    echo
    echo_wrap "  --udf\t\tCreate UDF disk image (Non ISO-9660 compliant)."
    echo_wrap "  --help\tDisplay this help and exit."
    echo
    return 0

  # Failure: Command 'mkisofs' is not available.
  elif ( ! command -v 'mkisofs' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 127

  # Failure: Patina has not been given an argument.
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 2 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Failure: A valid argument was not provided.
  elif [ -n "$2" ] && [ "$2" != '--udf' ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: The target exists, but is a file.
  elif [ -f "$1" ] ; then
    patina_raise_exception 'PE0014'
    return 1

  # Failure: The target directory does not exist.
  elif [ ! -d "$1" ] ; then
    patina_raise_exception 'PE0004'
    return 1

  # Failure: The target disk image already exists.
  elif [ -f "$(basename "$1").iso" ] ; then
    patina_raise_exception 'PE0011'
    return 1

  # Success: Create ISO Disk Image (ISO-9660 compliant).
  elif [ -d "$1" ] && [ -z "$2" ] ; then
    mkisofs -volid "$(generate_volume_label)" -o "$(basename "$1").iso" \
      -input-charset UTF-8 \
      -joliet \
      -joliet-long \
      -rock \
      "$1"
    return 0

  # Success: Create ISO Disk Image (Non ISO-9660 compliant).
  elif [ -d "$1" ] && [ "$2" = '--udf' ] ; then
    mkisofs -volid "$(generate_volume_label)" -output "$(basename "$1").iso" \
      -input-charset UTF-8 \
      -udf \
      -allow-limited-size \
      -disable-deep-relocation \
      -untranslated-filenames \
      "$1"
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# EXPORTS #
###########

export -f 'patina_genisoimage'

###########
# ALIASES #
###########

# PATINA > FUNCTIONS > APPLICATIONS > GENISOIMAGE COMMANDS

alias 'p-iso'='patina_genisoimage'

# End of File.
