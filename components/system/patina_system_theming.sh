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
# along with this program. If not, see <http://www.gnu.org/licenses/>.

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
    patina_throw_exception 'PE0001'
    return

  # Failure: Patina has been given multiple arguments
  elif [ "$#" -gt "1" ] ; then
    patina_throw_exception 'PE0002'
    return

  # Default theme
  elif [ "$1" = 'default' ] ; then
    patina_theme_apply 'magenta'
    return

  # Standard themes
  elif [ "$1" = 'blue' ] ; then
    export patina_major_color="${light_blue}"
    export patina_minor_color="${blue}"

  elif [ "$1" = 'cyan' ] ; then
    export patina_major_color="${light_cyan}"
    export patina_minor_color="${cyan}"

  elif [ "$1" = 'green' ] ; then
    export patina_major_color="${light_green}"
    export patina_minor_color="${green}"

  elif [ "$1" = 'magenta' ] ; then
    export patina_major_color="${light_magenta}"
    export patina_minor_color="${magenta}"

  elif [ "$1" = 'red' ] ; then
    export patina_major_color="${light_red}"
    export patina_minor_color="${red}"

  elif [ "$1" = 'yellow' ] ; then
    export patina_major_color="${light_yellow}"
    export patina_minor_color="${yellow}"

  # Monochrome themes
  elif [ "$1" = 'black' ] ; then
    export patina_major_color="${black}"
    export patina_minor_color="${black}"

  elif [ "$1" = 'gray' ] || [ "$1" = 'grey' ] ; then
    export patina_major_color="${light_gray}"
    export patina_minor_color="${gray}"

  elif [ "$1" = 'white' ] ; then
    export patina_major_color="${white}"
    export patina_minor_color="${white}"

  # Additional themes
  elif [ "$1" = 'blossom' ] ; then
    export patina_major_color="${light_magenta}"
    export patina_minor_color="${light_red}"

  elif [ "$1" = 'classic' ] ; then
    export patina_major_color="${light_magenta}"
    export patina_minor_color="${light_cyan}"

  elif [ "$1" = 'cygwin' ] ; then
    export patina_major_color="${light_green}"
    export patina_minor_color="${light_yellow}"

  elif [ "$1" = 'gravity' ] ; then
    export patina_major_color="${light_magenta}"
    export patina_minor_color="${light_yellow}"

  elif [ "$1" = 'mint' ] ; then
    export patina_major_color="${light_green}"
    export patina_minor_color="${light_blue}"

  elif [ "$1" = 'varia' ] ; then
    export patina_major_color="${light_red}"
    export patina_minor_color="${light_yellow}"

  elif [ "$1" = 'water' ] ; then
    export patina_major_color="${light_blue}"
    export patina_minor_color="${cyan}"

  # Failure: Catch any other error condition here
  else
    patina_throw_exception 'PE0003'
    return
  fi

  # Export the selected theme
  export patina_theme="$1"

  # Success: Update configuration file
  if grep --quiet 'patina_theme=' "$patina_file_configuration" ; then
    sed -i "s/patina_theme=.*$/patina_theme=${patina_theme}/g" "$patina_file_configuration"

  # Failure: Rewrite configuration file
  else
    patina_create_configuration_file
    return
  fi

  # Refresh the prompt (enable diamond prefix for Fedora Silverblue Toolbox).
  if [ "$HOSTNAME" == 'toolbox' ] ; then
    export PS1="\\[\\e]2;Patina \\w\\a\\]${magenta}\\[\\]⬢\\[\\]${color_reset} \\[${patina_major_color}\\]\\u@\\h\\[${color_reset}\\] \\[${patina_minor_color}\\]\\w\\[${color_reset}\\] P\\$ "
  else
    export PS1="\\[\\e]2;Patina \\w\\a\\]\\[${patina_major_color}\\]\\u@\\h\\[${color_reset}\\] \\[${patina_minor_color}\\]\\w\\[${color_reset}\\] P\\$ "
  fi
}

patina_initialization_theme_apply() {
  if [ "$patina_theme" ] ; then
    patina_theme_apply "$patina_theme"
    return
  else
    export patina_theme=default
    patina_theme_apply "$patina_theme"
    return
  fi
}

###########
# Aliases #
###########

# Colors
alias 'p-theme'='patina_theme_apply'

#############
# Kickstart #
#############

patina_initialization_theme_apply

# End of File.
