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

patina_encode_wave_to_aac(){
  wav_count=$(find . -maxdepth 1 -name '*.wav' | wc -l)
  m4a_count=$(find . -maxdepth 1 -name '*.m4a' | wc -l)

  if [ "$1" = '--help' ]; then
    echo "Usage: p-wav2aac"
    echo "Batch convert all detected Wave files in current directory"
    echo "to highest quality AAC in variable bit rate (VBR)."
    echo "Dependencies: 'fdkaac' from package 'fdkaac'."
    echo
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0
  elif ( ! command -v 'fdkaac' > /dev/null 2>&1 ); then
    patina_raise_exception 'PE0006'
    patina_required_software 'fdkaac' 'fdkaac'
    return 127
  elif [ "$#" -gt 0 ]; then
    patina_raise_exception 'PE0002'
    return 1
  elif [ "${wav_count}" -eq 0 ]; then
    patina_raise_exception 'PE0005'
    return 1
  elif [ "${m4a_count}" -gt 0 ]; then
    patina_raise_exception 'PE0011'
    return 1
  elif [ "$#" -eq "0" ]; then
    for f in *.wav; do
      if [ -f "$f" ]; then
        album_name="$(basename "$(pwd)")"
        artist_name="$(basename "$(dirname "$(pwd)")")"
        file_name="$(basename "$f" .wav)"
        track_number=$(echo "$f" | awk '{print substr($0,0,2)}')
        track_title="$(echo "${file_name}" | cut -c 4-)"
        year="$(date +"%Y")"

        fdkaac --bitrate-mode 5 "$f" \
          --title "${track_title}" \
          --album "${album_name}" \
          --artist "${artist_name}" \
          --album-artist "${artist_name}" \
          --track "${track_number}/${wav_count}" \
          --date "${year}"
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

alias 'p-wav2aac'='patina_encode_wave_to_aac'

# End of File.
