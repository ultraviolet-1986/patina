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

patina_system_session() {
  if ( hash 'systemctl' ); then
    case "$1" in
      'reboot' | 'restart')
        printf "Do you wish to reboot your machine [Y/N]? "
        read -n1 -r answer
        case "$answer" in
          'Y'|'y') systemctl reboot ;;
          'N'|'n') echo ; return ;;
          *) patina_throw_exception 'PE0003' ; return ;;
        esac
        ;;
      'shutdown')
        printf "Do you wish to power down your machine [Y/N]? "
        read -n1 -r answer
        case "$answer" in
          'Y'|'y') systemctl poweroff ;;
          'N'|'n') echo ; return ;;
          *) patina_throw_exception 'PE0003' ; return ;;
        esac
        ;;
      *) patina_throw_exception 'PE0001' ; return ;;
    esac
  else
    patina_throw_exception 'PE0006'
    return
  fi
}

###########
# Aliases #
###########

alias 'p-session'='patina_system_session'

# End of File.
