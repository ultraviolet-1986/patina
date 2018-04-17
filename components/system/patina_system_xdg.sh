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
  if ( ! hash 'xdg-open' ) ; then
    patina_throw_exception 'PE0006'
  elif [ "$#" -eq "0" ] ; then
    cd || return
    xdg-open "$(pwd)" > /dev/null 2>&1
  elif [ ! -d "$1" ] ; then
    patina_throw_exception 'PE0004'
  elif [ -d "$1" ] && [ "$2" = '-g' ] ; then
    # Change directory in terminal and open graphically
    cd "$1" || return
    xdg-open "$(pwd)" > /dev/null 2>&1
  elif [ -d "$1" ] ; then
    # Change directory only
    cd "$1" || return
  else
    patina_throw_exception 'PE0000'
  fi
}

###########
# Aliases #
###########

# Folders
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

# End of File.
