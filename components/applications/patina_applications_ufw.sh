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
# Variables #
#############

readonly patina_file_ufw_help="$patina_path_resources_help/patina_applications_ufw_help.txt"

#############
# Functions #
#############

patina_ufw_configure() {
  if ( ! hash 'ufw' ) ; then
    patina_throw_exception 'PE0006'
    return

  elif [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
    return

  elif [ "$#" -gt "1" ] ; then
    patina_throw_exception 'PE0002'
    return

  elif [ "$1" ] ; then
    case "$1" in
      'disable') sudo ufw disable ;;
      'enable') sudo ufw enable ;;
      'help'|'?') patina_ufw_help ;;
      'setup') sudo ufw enable ; sudo ufw default deny ; sudo ufw limit ssh ;;
      'status') sudo ufw status ;;
      *) patina_throw_exception 'PE0003' ; return ;;
    esac

  else
    patina_throw_exception 'PE0000'
    return
  fi
}

patina_ufw_help() {
  clear
  echo_wrap "${underline}${patina_major_color}Patina / ufw Instructions${color_reset}\\n"
  echo_wrap "$(cat "${patina_file_ufw_help}")\\n"
}

###########
# Aliases #
###########

alias 'p-ufw'='patina_ufw_configure'

# End of File.
