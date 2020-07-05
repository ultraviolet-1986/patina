#!/usr/bin/env bash

###########
# License #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License along with this program. If not,
# see <http://www.gnu.org/licenses/>.

#########################
# ShellCheck Directives #
#########################

# Override SC2154: "var is referenced but not assigned".
# shellcheck disable=SC2154

#############
# Functions #
#############

# PATINA > FUNCTIONS > SYSTEM > SYSTEM SESSION

patina_system_session() {
  # Success: Display help and exit.
  if [ "$1" = '--help' ] ; then
    echo "Usage: p-session [OPTION]"
    echo "Manage current system session using 'systemd'."
    echo "Dependencies: 'systemctl' command from package 'systemd'."
    echo
    echo -e "  reboot\\tReboot the machine."
    echo -e "  restart\\tReboot the machine."
    echo -e "  shutdown\\tShut down the machine."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0

  elif ( command -v 'systemctl' > /dev/null 2>&1 ); then
    local patina_session_action=''

    if [ "$1" = 'reboot' ] || [ "$1" = 'restart' ] ; then
      patina_session_action='reboot'
    elif [ "$1" = 'shutdown' ] ; then
      patina_session_action='poweroff'
    else
      patina_raise_exception 'PE0001'
      return 1
    fi

    printf "Your current session will end. Do you wish to continue [Y/N]? "
    read -n1 -r answer
    echo

    case "$answer" in
      'Y' | 'y')
        systemctl "$patina_session_action"
        return 0
        ;;
      'N' | 'n')
        return 0
        ;;
      *)
        patina_raise_exception 'PE0003'
        return 1
        ;;
    esac
  else
    patina_raise_exception 'PE0006'
    return 127
  fi
}

###########
# Aliases #
###########

# PATINA > FUNCTIONS > SYSTEM > SYSTEM SESSION COMMANDS

alias 'p-session'='patina_system_session'

# End of File.
