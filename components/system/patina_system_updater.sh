#!/usr/bin/env bash

##############
# Directives #
##############

# Some variables are defined elsewhere
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_update() {
  patina_detect_internet_connection

  # Failure: Package 'git' is not installed
  if ( ! hash 'git' ) ; then
  echo_wrap "Patina cannot check for updates because package 'git' is not installed."

  # Failure: Patina root is not a 'git' repository
  elif ( ! git -C "$patina_path_root" rev-parse ) ; then
    echo_wrap "Patina cannot check for updates because it has not been installed or 'cloned into' using 'git' source control."

  # Failure: Patina is not connected to the Internet
  elif [ "$patina_has_internet" = 'false' ] ; then
    echo_wrap "Patina requires an Internet Connection to check for updates."

  # Success: Package 'git' is installed, Patina root is a 'git' repository, and Patina is connected to the Internet
  elif ( hash 'git' ) && ( git -C "$patina_path_root" rev-parse ) && [ "$patina_has_internet" = true ] ; then
    cd "$patina_path_root" || return

    # Synchronise repository with upstream
    echo
    git remote update

    # Define repository variables
    local patina_git_upstream=''
    local patina_git_local=''
    local patina_git_remote=''
    local patina_git_base=''

    patina_git_upstream="${1:-@{u}}"
    patina_git_local="$(git rev-parse @)"
    patina_git_remote="$(git rev-parse "$patina_git_upstream")"
    patina_git_base="$(git merge-base @ "$patina_git_upstream")"

    # Failure: Patina is up-to-date
    if [ "$patina_git_local" = "$patina_git_remote" ] ; then
      echo_wrap "Patina is up-to-date.\\n"

    # Success: Patina update is available
    elif [ "$patina_git_local" = "$patina_git_base" ] ; then
      printf "An update for Patina is available, download and restart [Y/N]?"
      read -n1 -r answer
      case "$answer" in
        'Y'|'y')
          echo
          git pull
          patina_terminal_refresh
          ;;
        'N'|'n')
          echo_wrap "\\n\\nPatina update cancelled.\\n"
          ;;
        *)
          echo_wrap "\\n\\nIncorrect answer, please try again.\\n"
          patina_update "$@"
          ;;
      esac

    # Failure: Catch any other error condition here
    else
      echo_wrap "Patina has encountered an unknown error.\\n"
    fi

    # Rubbish collection
    unset -v patina_git_upstream patina_git_local patina_git_remote patina_git_base

    # Return to the previous working directory
    cd ~- || return

  # Failure: Catch any other error condition here
  else
    echo_wrap "Patina has encountered an unknown error."
  fi
}

###########
# Aliases #
###########

alias 'p-update'='patina_update'

# End of File.
