#!/usr/bin/env bash

###########
# License #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

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
# Variables #
#############

export readonly PATINA_FILE_USER_COMMANDS="$PATINA_PATH_COMPONENTS_USER/patina_user_commands.sh"

#############
# Functions #
#############

patina_define_command() {
  # Success: Display help and exit.
  if [ "$1" = '-h' ] || [ "$1" = '--help' ] ; then
    echo "Usage: p-define [ALIAS] [COMMAND]"
    echo "Create a persistent alias for a command."
    echo
    echo -e "  -h, --help\\tDisplay this help and exit."
    echo
    return 0

  # Failure: An argument was not provided.
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Too many exceptions were provided.
  elif [ "$#" -ge 3 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Two arguments were provided.
  elif [ "$#" -eq 2 ] ; then
    # Create command definition file if not exists.
    if [ ! -f "$PATINA_FILE_USER_COMMANDS" ] ; then
      touch "$PATINA_FILE_USER_COMMANDS"
      echo -e "#!/usr/bin/env\n" > "$PATINA_FILE_USER_COMMANDS"
    fi

    # Append new command definition to the user-defined command file.
    echo -e "alias '$1'='$2'" | tee --append "$PATINA_FILE_USER_COMMANDS"

    # Re-source the file to enable immediate use of the new command(s).
    source "$PATINA_FILE_USER_COMMANDS"
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

#############
# Kickstart #
#############

alias 'p-define'='patina_define_command'

# End of File.
