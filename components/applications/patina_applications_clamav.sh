#!/bin/bash

##############
# Directives #
##############

# Color code variables are defined in 'patina.sh'
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_clamav_scan() {
  # Variables
  local patina_create_clamav_logfile=''
  local patina_clamav_logfile=''

  # Failure: Package 'clamav' is not installed
  if ( ! hash 'clamscan' ) ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot perform the virus scan because package ${patina_major_color}clamav${color_reset} is not installed.\\n"

  # Failure: A path has not been supplied
  elif [ "$#" -eq 0 ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot perform the scan because a path was not supplied.\\n"

  # Failure: Too many arguments have been supplied
  elif [ "$#" -gt 1 ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot perform the scan because too many paths were supplied. Please provide a single path.\\n"

  # Failure: A path was supplied, but does not exist
  elif [[ ! -e "$1" ]] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot perform the scan because a valid path was not supplied.\\n"

  # Success: A single path was supplied and it exists
  elif [ "$#" -ne 0 ] && [[ -e "$1" ]] ; then
    echo
    printf "Do you wish to record a log file in your home directory [Y/N]? "
    read -n1 -r answer
    case "$answer" in
      'Y' | 'y')
        patina_create_clamav_logfile='true'
        ;;
      'N' | 'n')
        patina_create_clamav_logfile='false'
        ;;
      *)
        echo_wrap "\\nIncorrect response, please try again.\\n"
        ;;
    esac

    # Assign the current date and time
    patina_clamav_logfile="clamscan_log_$(date +%Y%m%d_%H%M%S).txt"

    # Prepare and perform 'clamav' scan
    reset
    tput civis
    echo_wrap "Preparing ${patina_major_color}clamav${color_reset} virus scan, please wait...\\n"
    case "$patina_create_clamav_logfile" in
      true)
        clamscan -l ~/"$patina_clamav_logfile" -r "$1" -v
        ;;
      false)
        clamscan -r "$1" -v
        ;;
      *)
        echo_wrap "\\n${patina_major_color}Patina${color_reset} has encountered an unexpected error.\\n"
        ;;
    esac
    tput cnorm
    echo

  # Failure: Catch any other error condition here
  else
    echo_wrap "\\n${patina_major_color}Patina${color_reset} has encountered an unexpected error.\\n"
  fi
}

patina_clamav_help() {
  clear
  echo_wrap "${patina_major_color}Patina / ClamAV Instructions${color_reset}:\\n"
  echo_wrap "In order to perform a virus scan, you must provide a single, valid path when using the ${patina_minor_color}p-clamscan${color_reset} command, for example:\\n"
  echo_wrap "\\t${patina_major_color}\$ ${patina_minor_color}p-clamscan${color_reset} ~/Documents\\n"
  echo_wrap "For a path which contains empty space characters, you must wrap your path in single or double quotation marks, for example:\\n"
  echo_wrap "\\t${patina_major_color}\$ ${patina_minor_color}p-clamscan${color_reset} ~/\"My Documents\"\\n"
  echo_wrap "You can also perform a virus scan on the current working directory by using the following command:\\n"
  echo_wrap "\\t${patina_major_color}\$${patina_minor_color} p-clamscan${color_reset} .\\n"
  echo_wrap "When a valid path has been supplied, you will have the option to record a log file within your home directory before the scan begins.\\n"
  echo_wrap "This ${patina_major_color}Patina${color_reset} component uses ${patina_major_color}ClamAV${color_reset}, which can be found at: ${patina_major_color}https://www.clamav.net/${color_reset}.\\n"
}

###########
# Aliases #
###########

alias 'p-clamscan'='patina_clamav_scan'
alias 'p-clamscan-help'='patina_clamav_help'

# End of File.
