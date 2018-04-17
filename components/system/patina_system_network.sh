#!/usr/bin/env bash

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
  elif [ "$patina_has_internet" = 'false' ] ; then
    patina_throw_exception 'PE0008'
  elif [ ! "$patina_has_internet" ] ; then
    patina_show_network_status
  else
    patina_throw_exception 'PE0000'
  fi
}

patina_systemd_network_manager() {
  if [ "$patina_has_systemd" = 'false' ] ; then
    patina_throw_exception 'PE0006'
  elif [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0003'
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
  elif [ "$patina_has_systemd" = 'true' ] ; then
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
