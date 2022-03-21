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

patina_encode_wave_to_flac(){
  wav_count=$(find . -maxdepth 1 -name '*.wav' | wc -l)
  flac_count=$(find . -maxdepth 1 -name '*.flac' | wc -l)

  if [ "$1" = '--help' ]; then
    echo "Usage: p-wav2flac"
    echo "Batch encode all detected Wave files in current directory"
    echo "to FLAC."
    echo "Dependencies: 'flac' from package 'flac'."
    echo
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0

  elif ( ! command -v 'flac' > /dev/null 2>&1 ); then
    patina_raise_exception 'PE0006'
    patina_required_software 'flac' 'flac'
    return 127

  elif [ "$#" -gt 0 ]; then
    patina_raise_exception 'PE0002'
    return 1

  elif [ "$wav_count" -eq 0 ]; then
    patina_raise_exception 'PE0005'
    return 1

  elif [ "$flac_count" -gt 0 ]; then
    patina_raise_exception 'PE0011'
    return 1

  elif [ "$#" -eq "0" ]; then
    for f in ./*.wav; do
      if [ -f "$f" ]; then
        flac --best --verify -e "$f"
        sync
        echo
      fi
    done
    return 0

  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

patina_decode_flac_to_wave(){
  flac_count=$(find . -maxdepth 1 -name '*.flac' | wc -l)
  wav_count=$(find . -maxdepth 1 -name '*.wav' | wc -l)

  if [ "$1" = '--help' ]; then
    echo "Usage: p-flac2wave"
    echo "Batch decode all detected FLAC files in current directory"
    echo "to Wave."
    echo "Dependencies: 'flac' from package 'flac'."
    echo
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0

  elif ( ! command -v 'flac' > /dev/null 2>&1 ); then
    patina_raise_exception 'PE0006'
    patina_required_software 'flac' 'flac'
    return 127

  elif [ "$#" -gt 0 ]; then
    patina_raise_exception 'PE0002'
    return 1

  elif [ "$flac_count" -eq 0 ]; then
    patina_raise_exception 'PE0005'
    return 1

  elif [ "$wav_count" -gt 0 ]; then
    patina_raise_exception 'PE0011'
    return 1

  elif [ "$#" -eq "0" ]; then
    for f in ./*.flac; do
      if [ -f "$f" ]; then
        flac --decode "$f"
        sync
        echo
      fi
    done
    return 0

  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Aliases #
###########

alias 'p-wav2flac'='patina_encode_wave_to_flac'
alias 'p-flac2wav'='patina_decode_flac_to_wave'

# End of File.
