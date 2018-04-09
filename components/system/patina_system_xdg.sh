#!/usr/bin/env bash

##############
# Directives #
##############

# Some items are defined elsewhere
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_open_folder() {
  # Failure: Package 'xdg-utils' is not installed
  if ( ! hash 'xdg-open' ) ; then
    echo_wrap "Cannot resolve path because package 'xdg-utils' is not installed."

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
    echo_wrap "Patina cannot open the location because the path to directory '$1' was invalid or does not exist."
  fi
}

patina_open_file() {
  # Failure: Package 'xdg-utils' not installed
  if ( ! hash 'xdg-open' ) ; then
    echo_wrap "Cannot resolve path because package 'xdg-utils' is not installed."

  # Failure: An argument was not supplied
  elif [ "$#" -eq "0" ] ; then
    echo_wrap "Patina cannot open the file because a path was not specified."

  # Success: File exists
  elif [ -f "$1" ] ; then
    local file_location=''
    file_location=$(dirname "${1}")
    cd "$file_location" || return
    xdg-open "$1" > /dev/null 2>&1
    unset file_location

  # Failure: Catch any other error condition here
  else
    echo_wrap "Patina cannot open the location because the path to file '$1' was invalid or does not exist."
  fi
}

patina_open_url() {
  patina_detect_internet_connection

  # Failure: Package 'xdg-utils' not installed
  if ( ! hash 'xdg-open' ) ; then
    echo_wrap "Cannot resolve path because package 'xdg-utils' is not installed."

  # Success: The 'patina' argument was supplied
  elif [ "$1" = 'patina' ] ; then
    patina_open_url "$patina_metadata_url"

  # Failure: An argument was not specified
  elif [ "$#" -eq "0" ] ; then
    echo_wrap "Patina cannot open the URL because a link was not specified."

  # Failure: Patina is not connected to the internet
  elif [ "$patina_has_internet" = 'false' ] ; then
    echo_wrap "Patina is not connected to the Internet."

  # Success: URL is valid and exists
  elif [ "$1" ] && [[ "$1" == "http"* ]] ; then
    echo_wrap "The URL '$1' has been sent to the default web browser."
    xdg-open "$1" > /dev/null 2>&1

  # Failure: Catch any other error condition here
  else
    echo_wrap "Patina cannot open the location because the URL '$1' was invalid or does not exist."
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

# Resources
alias 'p-r'='patina_open_folder $patina_path_resources'
alias 'p-r-exceptions'='patina_open_folder $patina_path_resources_exceptions'
alias 'p-r-help'='patina_open_folder $patina_path_resources_help'

# Files
alias 'p-source'='patina_open_file $patina_file_source'
alias 'p-config'='patina_open_file $patina_file_configuration'

# URLs
alias 'p-url'='patina_open_url'

# End of File.
