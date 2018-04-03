#!/usr/bin/env bash

##############
# Directives #
##############

# Some variables are defined elsewhere
# shellcheck disable=SC2154

#############
# Variables #
#############

readonly patina_file_ufw_help="$patina_path_components_applications/patina_applications_ufw_help.txt"

#############
# Functions #
#############

patina_ufw_configure() {
  # Failure: Package 'ufw' is not installed
  if ( ! hash 'ufw' ) ; then
    echo_wrap "Patina cannot configure the firewall because package 'ufw' is not installed."

  # Failure: Patina has not been given an argument
  elif [ "$#" -eq "0" ] ; then
    echo_wrap "Patina has not been given an argument, please try again."

  # Failure: Patina has been given multiple arguments
  elif [ "$#" -gt "1" ] ; then
    echo_wrap "Patina must be given only one argument, please try again."

  # Success: Patina has been given a single argument
  elif [ "$1" ] ; then
    case "$1" in
      'disable') sudo ufw disable ;;
      'enable') sudo ufw enable ;;
      'help'|'?') patina_ufw_help ;;
      'reset')
        sudo ufw enable
        sudo ufw delete limit ssh
        ;;
      'setup')
        sudo ufw enable
        sudo ufw default deny
        sudo ufw limit ssh
        ;;
      'status') sudo ufw status ;;
      *)
        echo_wrap "Patina requires one of the following arguments: 'enable', 'disable', 'help', 'reset', 'setup', or 'status'."
        ;;
    esac

  # Failure: Catch any other error condition here
  else
    echo_wrap "Patina has encountered an unexpected error."
  fi
}

patina_ufw_help() {
  clear
  echo_wrap "${underline}${patina_major_color}Patina / ufw Instructions${color_reset}\\n"
  echo_wrap "$(cat "${patina_file_ufw_help}")\\n"
}

###########
# Aliases #
###########

alias 'p-ufw'='patina_ufw_configure'

# End of File.
