#!/usr/bin/env bash

##############
# Directives #
##############

# Some items are defined elsewhere
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_update() {
  patina_detect_internet_connection

  # Failure: Package 'git' is not installed
  if ( ! hash 'git' ) ; then
    patina_throw_exception 'PE0006'

  # Failure: Patina root is not a 'git' repository
  elif ( ! git -C "$patina_path_root" rev-parse ) ; then
    patina_throw_exception 'PE0009'

  # Failure: Patina is not connected to the Internet
  elif [ "$patina_has_internet" = 'false' ] ; then
    patina_throw_exception 'PE0008'

  # Success: Patina will check for newer 'git' commits
  elif ( git -C "$patina_path_root" rev-parse ) ; then
    cd "$patina_path_root" || return
    git pull
    cd ~- || return

  # Failure: Catch any other error condition here
  else
    patina_throw_exception 'PE0000'
  fi
}

###########
# Aliases #
###########

alias 'p-update'='patina_update'

# End of File.
