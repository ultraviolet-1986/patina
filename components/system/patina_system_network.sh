#!/bin/bash

##############
# Directives #
##############

# Some variables are defined elsewhere
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_detect_internet_connection() {
  if ( ping -c 1 8.8.8.8 ) &> /dev/null ; then
    patina_has_internet='true'
  else
    patina_has_internet='false'
  fi
}

patina_show_network_status() {
  patina_detect_internet_connection

  if [ "$patina_has_internet" = 'true' ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} is ${patina_minor_color}connected${color_reset} to the Internet.\\n"

  elif [ "$patina_has_internet" = 'false' ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} is ${patina_minor_color}not connected${color_reset} to the Internet.\\n"

  elif [ ! "$patina_has_internet" ] ; then
    patina_show_network_status

  else
    echo_wrap "\\n${patina_major_color}Patina${color_reset} has encountered an unknown error.\\n"
  fi
}

patina_systemd_network_manager() {
  # Failure: Patina is not running in a 'systemd' environment
  if [ "$patina_has_systemd" = 'false' ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} has not detected ${patina_minor_color}systemd${color_reset} and therefore cannot execute your command.\\n"

  # Failure: Patina has not been given an argument
  elif [ "$#" -eq "0" ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} has not been given a valid argument, please try again.\\n"

  # Failure: Patina has been given too many arguments
  elif [ "$#" -gt 1 ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} must be given only one argument, please try again.\\n"

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
        echo_wrap "\\n${patina_major_color}$1${color_reset} is not a valid argument, please try again.\\n"
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
