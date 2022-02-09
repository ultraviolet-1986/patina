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

patina_encode_wave_to_vorbis(){
  wav_count=$(find . -maxdepth 1 -name '*.wav' | wc -l)
  local wav_count

  ogg_count=$(find . -maxdepth 1 -name '*.ogg' | wc -l)
  local ogg_count

  # Success: Display help and exit.
  if [ "$1" = '--help' ]; then
    echo "Usage: p-wav2vorbis"
    echo "Batch convert all detected Wave files in current directory"
    echo "to highest quality Vorbis in variable bit rate (VBR)."
    echo "Dependencies: 'oggenc' from package 'vorbis-tools'."
    echo
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0

  # Failure: Command 'oggenc' is not available.
  elif ( ! command -v 'oggenc' > /dev/null 2>&1 ); then
    patina_raise_exception 'PE0006'
    patina_required_software 'oggenc' 'ogg-tools'
    return 127

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 0 ]; then
    patina_raise_exception 'PE0002'
    return 1

  # Failure: No Wave files were detected.
  elif [ "$wav_count" == 0 ]; then
    patina_raise_exception 'PE0005'
    return 1

  # Failure: Patina will not overwrite pre-existing Vorbis files.
  elif [ "$ogg_count" -gt 0 ]; then
    patina_raise_exception 'PE0011'
    return 1

  # Success: An argument was not provided.
  elif [ "$#" -eq "0" ]; then
    for f in ./*.wav; do
      if [ -f "$f" ]; then
        oggenc -q 5 "$f" -o "$(basename "$f" .wav).ogg"
        sync
        echo
      fi
    done
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Aliases #
###########

alias 'p-wav2vorbis'='patina_encode_wave_to_vorbis'

# End of File.
