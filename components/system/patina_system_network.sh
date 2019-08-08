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

####################
# Global Variables #
####################

patina_has_internet=''

#############
# Functions #
#############

patina_detect_internet_connection() {
  if ( ping -c 1 1.1.1.1 ) &> /dev/null ; then
    patina_has_internet='true'
  else
    patina_has_internet='false'
  fi
}

patina_show_network_status() {
  # Prerequisite: Detect an Internet connection.
  patina_detect_internet_connection

  if [ "$patina_has_internet" = 'true' ] ; then
    echo_wrap "Patina has access to the Internet."
  elif [ "$patina_has_internet" = 'false' ] ; then
    patina_throw_exception 'PE0008'
  elif [ -z "$patina_has_internet" ] ; then
    patina_show_network_status

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi
}

patina_systemd_network_manager() {
  if ( ! command -v 'systemctl' ) ; then
    patina_throw_exception 'PE0006'
  elif [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0003'
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'

  elif ( command -v 'systemctl' ) ; then
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
        return
        ;;
      'stop')
        # Pass argument to system and continue.
        ;;
      *)
        patina_throw_exception 'PE0003'
        ;;
    esac

    sleep 0.1
    systemctl "$1" NetworkManager.service

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
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
