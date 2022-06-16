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

patina_detect_internet_connection() {
  ( ping -c 1 1.1.1.1 &> /dev/null ) && return 0 || return 1
}

patina_show_network_status() {
  if patina_detect_internet_connection ; then
    echo -e "${GREEN}Patina has access to the Internet.${COLOR_RESET}"
    return 0
  else
    patina_raise_exception 'PE0008'
    return 1
  fi
}

patina_systemd_network_manager() {
  if [ "$1" = '--help' ] ; then
    echo "Usage: p-network [OPTION]"
    echo "Manage various Network settings using 'systemd'."
    echo "Dependencies: 'systemctl' command from package 'systemd'."
    echo
    echo -e "  disable\\tDisable Network services."
    echo -e "  enable\\tEnable Network services."
    echo -e "  restart\\tRestart Network services."
    echo -e "  start\\t\\tStart Network services."
    echo -e "  status\\tReview Network service status."
    echo -e "  stop\\t\\tStop Network services."
    echo -e "  --help\\tDisplay this help and exit."
    echo
    return 0
  elif ( ! command -v 'systemctl' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 127
  elif [ "$#" -eq "0" ] ; then
    patina_raise_exception 'PE0003'
    return 1
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1
  elif ( command -v 'systemctl' > /dev/null 2>&1 ) ; then
    local network_command="systemctl '$1' NetworkManager.service"

    case "$1" in
      'disable')
        eval "${network_command}"
        ;;
      'enable')
        eval "${network_command}"
        ;;
      'restart')
        eval "${network_command}"
        ;;
      'start')
        eval "${network_command}"
        ;;
      'status')
        patina_show_network_status
        return "$?"
        ;;
      'stop')
        eval "${network_command}"
        ;;
      *)
        patina_raise_exception 'PE0003'
        return 1
        ;;
    esac

    return 0
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Exports #
###########

export -f 'patina_detect_internet_connection'

###########
# Aliases #
###########

alias 'p-network'='patina_systemd_network_manager'

# End of File.
