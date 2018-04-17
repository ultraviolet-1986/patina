#!/usr/bin/env bash

##############
# Directives #
##############

# Some items are defined elsewhere
# shellcheck disable=SC2154

#############
# Variables #
#############

readonly patina_file_ufw_help="$patina_path_resources_help/patina_applications_ufw_help.txt"

#############
# Functions #
#############

patina_ufw_configure() {
  if ( ! hash 'ufw' ) ; then
    patina_throw_exception 'PE0006'
  elif [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
  elif [ "$#" -gt "1" ] ; then
    patina_throw_exception 'PE0002'
  elif [ "$1" ] ; then
    case "$1" in
      'disable') sudo ufw disable ;;
      'enable') sudo ufw enable ;;
      'help'|'?') patina_ufw_help ;;
      'setup') sudo ufw enable ; sudo ufw default deny ; sudo ufw limit ssh ;;
      'status') sudo ufw status ;;
      *) patina_throw_exception 'PE0003' ; return ;;
    esac
  else
    patina_throw_exception 'PE0000'
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
