#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2019 William Willis Whinn

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

patina_system_detect_display_server() {
  # Failure: Success condition(s) not met.
  if [ -z "$XDG_SESSION_TYPE" ] ; then
    patina_throw_exception 'PE0010'

  # Success: Display the currently active Display Server.
  elif [ "$XDG_SESSION_TYPE" = 'x11' ] ; then
    echo_wrap "Patina has detected that your session is running under ${patina_major_color}X11/Xorg${color_reset}."
  elif [ "$XDG_SESSION_TYPE" = 'wayland' ] ; then
    echo_wrap "Patina has detected that your session is running under ${patina_major_color}Wayland${color_reset}."
  elif [ "$XDG_SESSION_TYPE" = 'tty' ] ; then
    echo_wrap "Patina has detected that your session is running as a ${patina_major_color}Headless Server${color_reset}."

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi
}

###########
# Aliases #
###########

alias 'p-display'='patina_system_detect_display_server'

# End of File.
