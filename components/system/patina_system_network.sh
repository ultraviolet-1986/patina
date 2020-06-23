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
# Variables #
#############

# Patina > Global Variables > Internet Status

PATINA_HAS_INTERNET=''

#############
# Functions #
#############

patina_detect_internet_connection() {
  if ( ping -c 1 1.1.1.1 ) &> /dev/null ; then
    PATINA_HAS_INTERNET='true'
    return 0
  else
    PATINA_HAS_INTERNET='false'
    return 0
  fi
}

patina_show_network_status() {
  # Prerequisite: Detect an Internet connection.
  patina_detect_internet_connection

  if [ "$PATINA_HAS_INTERNET" = 'true' ] ; then
    echo_wrap "Patina has access to the Internet."
    return 0
  elif [ "$PATINA_HAS_INTERNET" = 'false' ] ; then
    patina_raise_exception 'PE0008'
    return 0
  elif [ -z "$PATINA_HAS_INTERNET" ] ; then
    patina_show_network_status
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

patina_systemd_network_manager() {
  if ( ! command -v 'systemctl' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 1
  elif [ "$#" -eq "0" ] ; then
    patina_raise_exception 'PE0003'
    return 1
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  elif ( command -v 'systemctl' > /dev/null 2>&1 ) ; then
    case "$1" in
      'disable')
        # Pass argument to system and continue.
        ;;
      'enable')
        # Pass argument to system and continue.
        ;;
      'restart')
        # Pass argument to system and continue.
        ;;
      'start')
        # Pass argument to system and continue.
        ;;
      'status')
        patina_show_network_status
        return 0
        ;;
      'stop')
        # Pass argument to system and continue.
        ;;
      *)
        patina_raise_exception 'PE0003'
        return 1
        ;;
    esac

    sleep 0.1
    systemctl "$1" NetworkManager.service
    return 0

  # Failure: Catch all.
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

# Patina > Aliases > Network Management Commands

alias 'p-network'='patina_systemd_network_manager'

# End of File.
