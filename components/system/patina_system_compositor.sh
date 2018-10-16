#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2018 William Willis Whinn

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

##############
# Directives #
##############

# Some items are defined elsewhere
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_detect_system_compositor() {
  if [ "$XDG_SESSION_TYPE" = 'x11' ] ; then
    echo -e "Patina has detected your desktop is running under ${patina_major_color}Xorg${color_reset}."
  elif [ "$XDG_SESSION_TYPE" = 'wayland' ] ; then
    echo -e "Patina has detected your desktop is running under ${patina_major_color}Wayland${color_reset}."
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

###########
# Aliases #
###########

alias 'p-compositor'='patina_detect_system_compositor'

# End of File.
