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
    echo_wrap "Patina is connected to the Internet."

  elif [ "$patina_has_internet" = 'false' ] ; then
    echo_wrap "Patina is not connected to the Internet."

  elif [ ! "$patina_has_internet" ] ; then
    patina_show_network_status

  else
    echo_wrap "Patina has encountered an unknown error."
  fi
}

patina_systemd_network_manager() {
  # Failure: Patina is not running in a 'systemd' environment
  if [ "$patina_has_systemd" = 'false' ] ; then
    echo_wrap "Patina has not detected systemd and therefore cannot execute your command."

  # Failure: Patina has not been given an argument
  elif [ "$#" -eq "0" ] ; then
    echo_wrap "Patina has not been given a valid argument, please try again."

  # Failure: Patina has been given too many arguments
  elif [ "$#" -gt 1 ] ; then
    echo_wrap "Patina must be given only one argument, please try again."

  # Success: Patina is running in a 'systemd' environment and has been given a single argument
  elif [ "$patina_has_systemd" = 'true' ] && [ "$1" ] ; then
    case "$1" in
      'disable') ;;
      'enable') ;;
      'restart') ;;
      'start') ;;
      'status') patina_show_network_status ; return ;;
      'stop') ;;
      *)
        echo_wrap "'$1' is not a valid argument, please try again."
        return
        ;;
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
