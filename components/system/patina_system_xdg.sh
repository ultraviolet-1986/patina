#!/bin/bash

##############
# Directives #
##############

# Some variables are defined elsewhere
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_open_folder() {
  # Failure: Package 'xdg-utils' is not installed
  if ( ! hash 'xdg-open' ) ; then
    echo_wrap "\\nCannot resolve path because package ${patina_major_color}xdg-utils${color_reset} is not installed.\\n"

  # Failure: A path has not been supplied
  elif [ "$#" -eq "0" ] ; then
    cd || return
    xdg-open "$(pwd)" > /dev/null 2>&1

  # Success: A path was supplied and it exists
  elif [ -d "$1" ] ; then
    cd "$1" || return
    xdg-open "$(pwd)" > /dev/null 2>&1

  # Failure: Catch any other error condition here
  else
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot open the location because the path to directory ${patina_minor_color}$1${color_reset} was invalid or does not exist.\\n"
  fi
}

patina_open_file() {
  # Failure: Package 'xdg-utils' not installed
  if ( ! hash 'xdg-open' ) ; then
    echo_wrap "\\nCannot resolve path because package ${patina_major_color}xdg-utils${color_reset} is not installed.\\n"

  # Failure: An argument was not supplied
  elif [ "$#" -eq "0" ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot open the file because a path was not specified.\\n"

  # Success: File exists
  elif [ -f "$1" ] ; then
    local file_location=''
    file_location=$(dirname "${1}")
    cd "$file_location" || return
    xdg-open "$1" > /dev/null 2>&1
    unset file_location

  # Failure: Catch any other error condition here
  else
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot open the location because the path to file ${patina_minor_color}$1${color_reset} was invalid or does not exist.\\n"
  fi
}

patina_open_url() {
  patina_detect_internet_connection

  # Failure: Package 'xdg-utils' not installed
  if ( ! hash 'xdg-open' ) ; then
    echo_wrap "\\nCannot resolve path because package ${patina_major_color}xdg-utils${color_reset} is not installed.\\n"

  # Failure: An argument was not specified
  elif [ "$#" -eq "0" ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot open the URL because a link was not specified.\\n"

  # Failure: Patina is not connected to the internet
  elif [ "$patina_has_internet" = 'false' ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} is ${patina_minor_color}not connected${color_reset} to the Internet.\\n"

  # Success: URL exists
  elif [ "$1" ] ; then
    echo_wrap "\\nThe URL ${patina_minor_color}$1${color_reset} has been sent to the default web browser.\\n"
    xdg-open "$1" > /dev/null 2>&1

  # Failure: Catch any other error condition here
  else
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot open the location because the URL ${patina_minor_color}$1${color_reset} was invalid or does not exist.\\n"
  fi
}

###########
# Aliases #
###########

# Folders
alias 'files'='patina_open_folder'
alias 'p-root'='patina_open_folder $patina_path_root'

# Components
alias 'p-c'='patina_open_folder $patina_path_components'
alias 'p-c-applications'='patina_open_folder $patina_path_components_applications'
alias 'p-c-places'='patina_open_folder $patina_path_components_places'
alias 'p-c-system'='patina_open_folder $patina_path_components_system'
alias 'p-c-user'='patina_open_folder $patina_path_components_user'

# Files
alias 'p-source'='patina_open_file $patina_file_source'
alias 'p-config'='patina_open_file $patina_file_configuration'

# URLs
alias 'p-url-patina'='patina_open_url $patina_metadata_url'

# End of File.
