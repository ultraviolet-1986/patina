#!/usr/bin/env bash

###########
# License #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License along with this program. If not,
# see <http://www.gnu.org/licenses/>.

#############
# Variables #
#############

# PATINA > GLOBAL VARIABLES > PATHS > WORKSPACE DIRECTORY

export readonly PATINA_PATH_WORKSPACE="$HOME/Documents/Workspace"

export readonly PATINA_PATH_WORKSPACE_GIT="$PATINA_PATH_WORKSPACE/git"

#############
# Functions #
#############

# PATINA > FUNCTIONS > PLACES > WORKSPACE

patina_workspace_bootstrap() {

  mkdir -p "$PATINA_PATH_WORKSPACE"

  # Detect 'git' executable and create workspace directory.
  if ( command -v 'git' > /dev/null 2>&1 ) ; then
    mkdir -p "$PATINA_PATH_WORKSPACE_GIT"
  fi

  return 0
}

patina_workspace_update_git_repositories() {
  # Failure: Patina could not detect an active Internet connection.
  if ( ! patina_detect_internet_connection ) ; then
    patina_raise_exception 'PE0008'
    return 1

  # Failure: 'git' was not detected.
  elif ( ! command -v 'git' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 127

  # Failure: '$PATINA_PATH_WORKSPACE_GIT' is empty.
  elif ( ! ls -A "$PATINA_PATH_WORKSPACE_GIT" > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0019'
    return 1

  # Success: 'git' was detected.
  elif ( command -v 'git' > /dev/null 2>&1 ) ; then
    mkdir -p "$PATINA_PATH_WORKSPACE_GIT"

    echo -e "\\n${BOLD}Updating Detected 'git' Repositories${COLOR_RESET}\\n"

    for f in "$PATINA_PATH_WORKSPACE_GIT"/* ; do
      # Success: Target is a directory and a 'git' repository.
      if [ -d "$f" ] && ( git -C "$f" rev-parse > /dev/null 2>&1 ) ; then
        cd "$f" || return 1
        printf "Updating repository %b%s%b... " "${YELLOW}" "$( basename "$f" )" "${COLOR_RESET}"
        if ( git remote show origin > /dev/null 2>&1 ) ; then
          git pull > /dev/null 2>&1
          echo -e "${GREEN}Done${COLOR_RESET}"
        else
          echo -e "${RED}Error${COLOR_RESET}"
        fi
        cd ~- || return 1

      # Target is a file. Ignore.
      elif [ -f "$f" ] ; then
        continue

      # Target is a directory, but not a valid 'git' repository.
      else
        printf "Directory %b%s%b is not a valid 'git' repository." \
          "${YELLOW}" "$( basename "$f" )" "${COLOR_RESET}"
        echo
      fi
    done

    echo

    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Aliases #
###########

# PATINA > FUNCTIONS > PLACES > WORKSPACE COMMANDS

alias 'p-workspace'='patina_workspace_bootstrap'
alias 'p-gitupdate'='patina_workspace_update_git_repositories'

# PATINA > FUNCTIONS > FILE MANAGER COMMANDS > WORKSPACE DIRECTORY

alias 'p-w'='patina_open_folder "$PATINA_PATH_WORKSPACE"'
alias 'p-w-git'='patina_open_folder "$PATINA_PATH_WORKSPACE_GIT"'

# End of File.
