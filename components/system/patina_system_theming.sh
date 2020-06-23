#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

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

#########################
# ShellCheck Directives #
#########################

# Override SC2154: "var is referenced but not assigned".
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_theme_apply() {
  # Failure: Patina has not been given an argument
  if [ "$#" -eq "0" ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given multiple arguments
  elif [ "$#" -gt "1" ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Default theme
  elif [ "$1" = 'default' ] ; then
    patina_theme_apply 'magenta'
    return 0

  # Standard themes
  elif [ "$1" = 'blue' ] ; then
    export PATINA_MAJOR_COLOR="${light_blue}"
    export PATINA_MINOR_COLOR="${blue}"

  elif [ "$1" = 'cyan' ] ; then
    export PATINA_MAJOR_COLOR="${light_cyan}"
    export PATINA_MINOR_COLOR="${cyan}"

  elif [ "$1" = 'green' ] ; then
    export PATINA_MAJOR_COLOR="${light_green}"
    export PATINA_MINOR_COLOR="${green}"

  elif [ "$1" = 'magenta' ] ; then
    export PATINA_MAJOR_COLOR="${light_magenta}"
    export PATINA_MINOR_COLOR="${MAGENTA}"

  elif [ "$1" = 'red' ] ; then
    export PATINA_MAJOR_COLOR="${light_red}"
    export PATINA_MINOR_COLOR="${red}"

  elif [ "$1" = 'yellow' ] ; then
    export PATINA_MAJOR_COLOR="${light_yellow}"
    export PATINA_MINOR_COLOR="${yellow}"

  # Monochrome themes
  elif [ "$1" = 'black' ] ; then
    export PATINA_MAJOR_COLOR="${black}"
    export PATINA_MINOR_COLOR="${black}"

  elif [ "$1" = 'gray' ] || [ "$1" = 'grey' ] ; then
    export PATINA_MAJOR_COLOR="${light_gray}"
    export PATINA_MINOR_COLOR="${gray}"

  elif [ "$1" = 'white' ] ; then
    export PATINA_MAJOR_COLOR="${white}"
    export PATINA_MINOR_COLOR="${white}"

  # Additional themes
  elif [ "$1" = 'blossom' ] ; then
    export PATINA_MAJOR_COLOR="${light_magenta}"
    export PATINA_MINOR_COLOR="${light_red}"

  elif [ "$1" = 'classic' ] ; then
    export PATINA_MAJOR_COLOR="${light_magenta}"
    export PATINA_MINOR_COLOR="${light_cyan}"

  elif [ "$1" = 'cygwin' ] ; then
    export PATINA_MAJOR_COLOR="${light_green}"
    export PATINA_MINOR_COLOR="${light_yellow}"

  elif [ "$1" = 'gravity' ] ; then
    export PATINA_MAJOR_COLOR="${light_magenta}"
    export PATINA_MINOR_COLOR="${light_yellow}"

  elif [ "$1" = 'mint' ] ; then
    export PATINA_MAJOR_COLOR="${light_green}"
    export PATINA_MINOR_COLOR="${light_blue}"

  elif [ "$1" = 'varia' ] ; then
    export PATINA_MAJOR_COLOR="${light_red}"
    export PATINA_MINOR_COLOR="${light_yellow}"

  elif [ "$1" = 'water' ] ; then
    export PATINA_MAJOR_COLOR="${light_blue}"
    export PATINA_MINOR_COLOR="${cyan}"

  # Failure: Catch any other error condition here
  else
    patina_raise_exception 'PE0003'
    return 1
  fi

  # Export the selected theme
  export PATINA_THEME="$1"

  # Success: Update configuration file
  if grep --quiet 'PATINA_THEME=' "$PATINA_FILE_CONFIGURATION" ; then
    sed -i "s/PATINA_THEME=.*$/PATINA_THEME=${PATINA_THEME}/g" "$PATINA_FILE_CONFIGURATION"

  # Failure: Rewrite configuration file
  else
    patina_create_configuration_file
    return 0
  fi

  # Define PS1 prompt properties.
  local window_title="\\[\\e]0;Patina\\a\\]"
  local toolbox_diamond="\\[${MAGENTA}\\]⬢\\[${COLOR_RESET}\\]"
  local user_host="\\[${PATINA_MAJOR_COLOR}\\]\\u@\\h\\[${COLOR_RESET}\\]"
  local working_directory="\\[${PATINA_MINOR_COLOR}\\]\\w\\[${COLOR_RESET}\\]"
  local command_scope="P\\$ "

  # Display a custom 'PS1' command prompt depending on the current environment.
  if [ "$HOSTNAME" == 'toolbox' ] && [ -v "$VARIANT_ID" ] && [ "$VARIANT_ID" == 'container' ] ; then
    export PS1="$window_title$toolbox_diamond $user_host $working_directory $command_scope"
    return 0
  else
    export PS1="$window_title$user_host $working_directory $command_scope"
    return 0
  fi
}

patina_initialization_theme_apply() {
  if [ "$PATINA_THEME" ] ; then
    patina_theme_apply "$PATINA_THEME"
    return 0
  else
    export PATINA_THEME='default'
    patina_theme_apply "$PATINA_THEME"
    return 0
  fi
}

###########
# Aliases #
###########

# Patina > Aliases > Theme Commands

alias 'p-theme'='patina_theme_apply'

#############
# Kickstart #
#############

patina_initialization_theme_apply

# End of File.
