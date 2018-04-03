#!/usr/bin/env bash

##############
# Directives #
##############

# Some variables are defined elsewhere
# shellcheck disable=SC2154

#############
# Variables #
#############

readonly patina_file_clamav_help="$patina_path_components_applications/patina_applications_clamav_help.txt"

#############
# Functions #
#############

patina_clamav_scan() {
  # Variables
  local patina_create_clamav_logfile=''
  local patina_clamav_logfile=''

  # Failure: Package 'clamav' is not installed
  if ( ! hash 'clamscan' ) ; then
    echo_wrap "Patina cannot perform the virus scan because package 'clamav' is not installed."

  # Success: The 'help' argument was supplied
  elif [ "$1" = 'help' ] || [ "$1" = '?' ] ; then
    patina_clamav_help

  # Failure: A path has not been supplied
  elif [ "$#" -eq 0 ] ; then
    echo_wrap "Patina cannot perform the scan because a path was not supplied."

  # Failure: Too many arguments have been supplied
  elif [ "$#" -gt 1 ] ; then
    echo_wrap "Patina cannot perform the scan because too many paths were supplied. Please provide a single path."

  # Failure: A path was supplied, but does not exist
  elif [[ ! -e "$1" ]] ; then
    echo_wrap "Patina cannot perform the scan because a valid path was not supplied."

  # Success: A single path was supplied and it exists
  elif [ "$#" -ne 0 ] && [[ -e "$1" ]] ; then
    echo
    printf "Do you wish to record a log file in your home directory [Y/N]? "
    read -n1 -r answer
    case "$answer" in
      'Y'|'y')
        patina_create_clamav_logfile='true'
        ;;
      'N'|'n')
        patina_create_clamav_logfile='false'
        ;;
      *)
        echo_wrap "Incorrect response, please try again."
        ;;
    esac

    # Assign the current date and time
    patina_clamav_logfile="clamscan_log_$(date +%Y%m%d_%H%M%S).txt"

    # Prepare and perform 'clamav' scan
    reset
    tput civis
    echo_wrap "Preparing 'clamav' virus scan, please wait...\\n"
    case "$patina_create_clamav_logfile" in
      true)
        clamscan -l ~/"$patina_clamav_logfile" -r "$1" -v
        ;;
      false)
        clamscan -r "$1" -v
        ;;
      *)
        echo_wrap "Patina has encountered an unexpected error."
        ;;
    esac
    tput cnorm
    echo

  # Failure: Catch any other error condition here
  else
    echo_wrap "Patina has encountered an unexpected error."
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

alias 'p-clamav'='patina_clamav_scan'
alias 'p-clamscan'='patina_clamav_scan'

# End of File.
