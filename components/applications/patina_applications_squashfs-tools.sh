#!/usr/bin/env bash

###########
# License #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2021 William Willis Whinn

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

##############
# References #
##############

# GitHub / Create an encrypted DVD with SquashFS and LUKS
# - https://tinyurl.com/yu4zjkv6

#############
# Functions #
#############

# PATINA > FUNCTIONS > APPLICATIONS > SQUASHFS-TOOLS

patina_squashfs-tools() {
  # Success: Display help and exit.
  if [ "$1" = '--help' ] ; then
    echo "Usage: p-squash [DIRECTORY] [OPTION]"
    echo "Create a read-only disk image in SquashFS format."
    echo "Dependencies: 'mksquashfs' command from package 'squashfs-tools'."
    echo
    echo -e "  --enc\\tCreate an encrypted disk image."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0

  # Failure: Command 'mksquashfs' is not available.
  elif ( ! command -v 'mksquashfs' > /dev/null 2>&1 ) ; then
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

  # Failure: The target exists, but is a file.
  elif [ -f "$1" ] ; then
    patina_raise_exception 'PE0014'
    return 1

  # Failure: The target directory does not exist.
  elif [ ! -d "$1" ] ; then
    patina_raise_exception 'PE0004'
    return 1

  # Failure: The target disk image already exists.
  elif [ -f "$(basename "$1").squashfs" ] ; then
    patina_raise_exception 'PE0011'
    return 1

  # Success: Create LUKS encrypted SquashFS image.
  elif [ -d "$1" ] && [ "$2" = '--enc' ] ; then
    mksquashfs "$1" "$1.luks.squashfs"

    truncate -s +8M "$1.luks.squashfs"

    cryptsetup -q reencrypt \
      --encrypt \
      --type luks2 \
      --resilience none \
      --disable-locks \
      --reduce-device-size 8M \
      "$1.luks.squashfs"

    truncate -s -4M "$1.luks.squashfs"

    return 0

  # Success: Create SquashFS disk image.
  elif [ -d "$1" ] ; then
    mksquashfs "$1" "$1.squashfs"
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Exports #
###########

# PATINA > FUNCTIONS > APPLICATIONS > SQUASHFS-TOOLS

export -f 'patina_squashfs-tools'

###########
# Aliases #
###########

# PATINA > FUNCTIONS > APPLICATIONS > SQUASHFS-TOOLS COMMANDS

alias 'p-squash'='patina_squashfs-tools'

# End of File.
