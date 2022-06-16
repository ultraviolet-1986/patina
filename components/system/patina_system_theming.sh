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

patina_theme_apply() {
  if [ "$1" = '--help' ] ; then
    echo "Usage: p-theme [OPTION]"
    echo "Change the current Patina theme."
    echo "Note: Theme settings are saved in [~/.config/patina/patina.conf]."
    echo
    echo -e "  default\\tApply light/dark magenta theme."
    echo -e "  blue\\t\\tApply light/dark blue theme."
    echo -e "  cyan\\t\\tApply light/dark cyan theme."
    echo -e "  green\\t\\tApply light/dark green theme."
    echo -e "  magenta\\tApply light/dark magenta theme."
    echo -e "  orange\\tApply light/dark orange theme."
    echo -e "  red\\t\\tApply light/dark red theme."
    echo -e "  teal\\t\\tApply light/dark teal theme."
    echo -e "  yellow\\tApply light/dark yellow theme."
    echo -e "  black\\t\\tApply basic black theme."
    echo -e "  gray\\t\\tApply basic light/dark gray theme."
    echo -e "  grey\\t\\tApply basic light/dark gray theme."
    echo -e "  white\\t\\tApply basic white theme."
    echo -e "  blossom\\tApply light magenta/light red theme."
    echo -e "  classic\\tApply light magenta/light cyan theme."
    echo -e "  cygwin\\tApply light green/light yellow theme."
    echo -e "  gravity\\tApply light magenta/light yellow theme."
    echo -e "  mint\\t\\tApply light green/light blue theme."
    echo -e "  varia\\t\\tApply light red/light yellow theme."
    echo -e "  water\\t\\tApply light blue/cyan theme."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0
  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Default Theme

  elif [ "$1" = 'default' ] ; then
    patina_theme_apply 'magenta'
    return 0

  # Standard Themes

  elif [ "$1" = 'blue' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_BLUE}"
    export PATINA_MINOR_COLOR="${BLUE}"

  elif [ "$1" = 'cyan' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_CYAN}"
    export PATINA_MINOR_COLOR="${CYAN}"

  elif [ "$1" = 'green' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_GREEN}"
    export PATINA_MINOR_COLOR="${GREEN}"

  elif [ "$1" = 'magenta' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_MAGENTA}"
    export PATINA_MINOR_COLOR="${MAGENTA}"

  elif [ "$1" = 'orange' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_ORANGE}"
    export PATINA_MINOR_COLOR="${ORANGE}"

  elif [ "$1" = 'red' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_RED}"
    export PATINA_MINOR_COLOR="${RED}"

  elif [ "$1" = 'teal' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_TEAL}"
    export PATINA_MINOR_COLOR="${TEAL}"

  elif [ "$1" = 'yellow' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_YELLOW}"
    export PATINA_MINOR_COLOR="${YELLOW}"

  # Monochrome Themes

  elif [ "$1" = 'black' ] ; then
    export PATINA_MAJOR_COLOR="${BLACK}"
    export PATINA_MINOR_COLOR="${BLACK}"

  elif [ "$1" = 'gray' ] || [ "$1" = 'grey' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_GRAY}"
    export PATINA_MINOR_COLOR="${GRAY}"

  elif [ "$1" = 'white' ] ; then
    export PATINA_MAJOR_COLOR="${WHITE}"
    export PATINA_MINOR_COLOR="${WHITE}"

  # Additional Themes

  elif [ "$1" = 'blossom' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_MAGENTA}"
    export PATINA_MINOR_COLOR="${LIGHT_RED}"

  elif [ "$1" = 'classic' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_MAGENTA}"
    export PATINA_MINOR_COLOR="${LIGHT_CYAN}"

  elif [ "$1" = 'cygwin' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_GREEN}"
    export PATINA_MINOR_COLOR="${LIGHT_YELLOW}"

  elif [ "$1" = 'gravity' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_MAGENTA}"
    export PATINA_MINOR_COLOR="${YELLOW}"

  elif [ "$1" = 'mint' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_GREEN}"
    export PATINA_MINOR_COLOR="${LIGHT_BLUE}"

  elif [ "$1" = 'varia' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_ORANGE}"
    export PATINA_MINOR_COLOR="${YELLOW}"

  elif [ "$1" = 'water' ] ; then
    export PATINA_MAJOR_COLOR="${LIGHT_BLUE}"
    export PATINA_MINOR_COLOR="${CYAN}"

  else
    patina_raise_exception 'PE0003'
    return 1
  fi

  export PATINA_THEME="$1"

  if grep --quiet 'PATINA_THEME=' "${PATINA_FILE_CONFIGURATION}" ; then
    sed -i "s/PATINA_THEME=.*$/PATINA_THEME=${PATINA_THEME}/g" "${PATINA_FILE_CONFIGURATION}"
  else
    patina_create_configuration_file
    return 0
  fi

  local window_title="\\[\\e]0;Patina\\a\\]"
  local toolbox_diamond="\\[${MAGENTA}\\]⬢\\[${COLOR_RESET}\\]"
  local user_host="\\[${PATINA_MAJOR_COLOR}\\]\\u@\\h\\[${COLOR_RESET}\\]"
  local working_directory="\\[${PATINA_MINOR_COLOR}\\]\\W\\[${COLOR_RESET}\\]"
  local command_scope="P\\$ "

  if [ -v "${VARIANT_ID}" ] && [ "${VARIANT_ID}" == 'container' ] ; then
    PS1="${window_title}${toolbox_diamond} ${user_host} ${working_directory} ${command_scope}"
    export PS1
    return 0
  else
    PS1="${window_title}${user_host} ${working_directory} ${command_scope}"
    export PS1
    return 0
  fi
}

patina_initialization_theme_apply() {
  if [ "${PATINA_THEME}" ] ; then
    patina_theme_apply "${PATINA_THEME}"
    return 0
  else
    PATINA_THEME='default'
    export PATINA_THEME
    patina_theme_apply "${PATINA_THEME}"
    return 0
  fi
}

###########
# Aliases #
###########

alias 'p-theme'='patina_theme_apply'

#############
# Kickstart #
#############

patina_initialization_theme_apply

# End of File.
