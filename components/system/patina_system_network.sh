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

##############
# Directives #
##############

# Some items are defined elsewhere
# shellcheck disable=SC2154

#############
# Variables #
#############

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
  patina_detect_internet_connection

  if [ "$patina_has_internet" = 'true' ] ; then
    echo_wrap "Patina has access to the Internet."
    return

  elif [ "$patina_has_internet" = 'false' ] ; then
    patina_throw_exception 'PE0008'
    return

  elif [ ! "$patina_has_internet" ] ; then
    patina_show_network_status
    return

  else
    patina_throw_exception 'PE0000'
    return
  fi
}

patina_systemd_network_manager() {
  if ( ! hash 'systemctl' ) ; then
    patina_throw_exception 'PE0006'
    return

  elif [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0003'
    return

  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
    return

  elif ( hash 'systemctl' ) ; then
    case "$1" in
      'disable') ;;
      'enable') ;;
      'restart') ;;
      'start') ;;
      'status') patina_show_network_status ; return ;;
      'stop') ;;
      *) patina_throw_exception 'PE0003' ; return ;;
    esac

    sleep 0.1
    systemctl "$1" NetworkManager.service
  fi
}

###########
# Aliases #
###########

alias 'p-network'='patina_systemd_network_manager'

# End of File.
