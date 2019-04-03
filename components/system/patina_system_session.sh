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
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#########################
# ShellCheck Directives #
#########################

# Override SC2154: "var is referenced but not assigned".
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_system_session() {
  if ( hash 'systemctl' ); then
    local patina_session_action=''

    if [ "$1" = 'reboot' ] || [ "$1" = 'restart' ] ; then
      patina_session_action='reboot'
    elif [ "$1" = 'shutdown' ] ; then
      patina_session_action='poweroff'
    else
      patina_throw_exception 'PE0001'
    fi

    printf "Your current session will end. Do you wish to continue [Y/N]? "
    read -n1 -r answer
    echo

    case "$answer" in
      'Y' | 'y')
        systemctl "$patina_session_action"
        ;;
      'N' | 'n')
        return
        ;;
      *)
        patina_throw_exception 'PE0003'
        ;;
    esac
  else
    patina_throw_exception 'PE0006'
  fi
}

###########
# Aliases #
###########

alias 'p-session'='patina_system_session'

# End of File.
