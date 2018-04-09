#!/usr/bin/env bash

##############
# Directives #
##############

# Some items are defined elsewhere
# shellcheck disable=SC2154

#############
# Variables #
#############

readonly patina_file_clamav_help="$patina_path_resources_help/patina_applications_clamav_help.txt"

#############
# Functions #
#############

patina_clamav_scan() {
  local patina_create_clamav_logfile=''
  local patina_clamav_logfile=''

  if ( ! hash 'clamscan' ) ; then
    patina_throw_exception 'PE0006'
  elif [ "$1" = 'help' ] || [ "$1" = '?' ] ; then
    patina_clamav_help
  elif [ "$#" -eq 0 ] ; then
    patina_throw_exception 'PE0001'
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
  elif [[ ! -e "$1" ]] ; then
    patina_throw_exception 'PE0004'
  elif [ "$#" -ne 0 ] && [[ -e "$1" ]] ; then
    echo
    printf "Do you wish to record a log file in your home directory [Y/N]? "
    read -n1 -r answer
    case "$answer" in
      'Y'|'y') patina_create_clamav_logfile='true' ;;
      'N'|'n') patina_create_clamav_logfile='false' ;;
      *) patina_throw_exception 'PE0003' ;;
    esac

    local patina_clamav_logfile="clamscan_log_$(date +%Y%m%d_%H%M%S).txt"

    reset
    tput civis
    echo_wrap "Preparing 'clamav' virus scan, please wait...\\n"
    case "$patina_create_clamav_logfile" in
      true) clamscan -l ~/"$patina_clamav_logfile" -r "$1" -v ;;
      false) clamscan -r "$1" -v ;;
      *) patina_throw_exception 'PE0000' ;;
    esac
    tput cnorm
    echo
  else
    patina_throw_exception 'PE0000'
  fi
}

patina_clamav_help() {
  clear
  echo_wrap "${underline}${patina_major_color}Patina / ClamAV Instructions${color_reset}\\n"
  echo_wrap "$(cat "${patina_file_clamav_help}")\\n"
}

###########
# Aliases #
###########

alias 'p-clamscan'='patina_clamav_scan'

# End of File.
