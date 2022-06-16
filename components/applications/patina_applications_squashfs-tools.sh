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

##############
# References #
##############

# - https://tinyurl.com/yu4zjkv6

#############
# Functions #
#############

patina_squashfs-tools() {
  if [ "$1" = '--help' ] ; then
    echo "Usage: p-squash [DIRECTORY] [OPTION]"
    echo "Create a read-only disk image in SquashFS format."
    echo "Dependencies: 'mksquashfs' command from package 'squashfs-tools'."
    echo
    echo -e "  --enc\\tCreate an encrypted disk image."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0
  elif ( ! command -v 'mksquashfs' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    patina_required_software 'mksquashfs' 'squashfs-tools'
    return 127
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1
  elif [ "$#" -gt 2 ] ; then
    patina_raise_exception 'PE0002'
    return 1
  elif [ -f "$1" ] ; then
    patina_raise_exception 'PE0014'
    return 1
  elif [ ! -d "$1" ] ; then
    patina_raise_exception 'PE0004'
    return 1
  elif [ -f "$(basename "$1").squashfs" ] ; then
    patina_raise_exception 'PE0011'
    return 1

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

  elif [ -d "$1" ] ; then
    mksquashfs "$1" "$1.squashfs"
    return 0
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Exports #
###########

export -f 'patina_squashfs-tools'

###########
# Aliases #
###########

alias 'p-squash'='patina_squashfs-tools'

# End of File.
