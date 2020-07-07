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
# Functions #
#############

# PATINA > FUNCTIONS > PLACES > WORKSPACE

patina_workspace_bootstrap() {
  local workspace_directory="$HOME/Documents/Workspace"

  mkdir -p "$workspace_directory"

  # Detect 'git' executable and create workspace directory.
  if ( command -v 'git' > /dev/null 2>&1 ) ; then
    mkdir -p "$workspace_directory/git"
  fi

  # Detect 'C' compiler (gcc) and create workspace directory.
  if ( command -v 'gcc' > /dev/null 2>&1 ) ; then
    mkdir -p "$workspace_directory/C"
  fi

  # Detect 'C++' compiler (g++) and create workspace directory.
  if ( command -v 'gcc' > /dev/null 2>&1 ) ; then
    mkdir -p "$workspace_directory/C++"
  fi

  # Detect 'BASH' shell scripting language and create workspace directory.
  if ( command -v 'bash' > /dev/null 2>&1 ) ; then
    mkdir -p "$workspace_directory/BASH"
  fi

  # Detect 'Perl' programming language and create workspace directory.
  if ( command -v 'perl' > /dev/null 2>&1 ) ; then
    mkdir -p "$workspace_directory/Perl"
  fi

  # Detect 'Python' programming language and create workspace directory.
  if ( command -v 'python' > /dev/null 2>&1 ) ; then
    mkdir -p "$workspace_directory/Python"
  fi

  # Detect 'R' programming language and create workspace directory.
  if ( command -v 'R' > /dev/null 2>&1 ) ; then
    mkdir -p "$workspace_directory/R"
  fi

  # Detect 'Ruby' programming language and create workspace directory.
  if ( command -v 'irb' > /dev/null 2>&1 ) ; then
    mkdir -p "$workspace_directory/Ruby"
  fi

  return 0
}

patina_workspace_update_git_repository() {
  local git_workspace="$HOME/Documents/Workspace/git"

  patina_detect_internet_connection

  # Failure: Patina could not detect an active Internet connection.
  if [ "$PATINA_HAS_INTERNET" == 'false' ] ; then
    patina_raise_exception 'PE0008'
    return 1

  # Failure: 'git' was not detected.
  elif ( ! command -v 'git' > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0006'
    return 127

  # Failure: '$git_workspace' is empty.
  elif ( ! ls -A "$git_workspace" > /dev/null 2>&1 ) ; then
    patina_raise_exception 'PE0019'
    return 1

  # Success: 'git' was detected.
  elif ( command -v 'git' > /dev/null 2>&1 ) ; then
    mkdir -p "$git_workspace"

    echo -e "\\n${BOLD}Updating Detected 'git' Repositories${COLOR_RESET}\\n"

    for f in "$git_workspace"/* ; do
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
alias 'p-gitupdate'='patina_workspace_update_git_repository'

# End of File.
