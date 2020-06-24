#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#########################
# ShellCheck Directives #
#########################

# Override SC1090: "Can't follow non-constant source".
# shellcheck source=/dev/null

# Override SC2154: "var is referenced but not assigned".
# shellcheck disable=SC2154

#############
# Variables #
#############

# Patina > Global Variables > Patina Metadata

readonly PATINA_VERSION='0.7.8'
readonly PATINA_CODENAME='Duchess'
readonly PATINA_URL='https://github.com/ultraviolet-1986/patina'

# Patina > Global Variables > Text Formatting > Text Colors

export readonly BLUE='\e[34m'
export readonly CYAN='\e[36m'
export readonly GREEN='\e[32m'
export readonly MAGENTA='\e[35m'
export readonly RED='\e[31m'
export readonly YELLOW='\e[33m'

export readonly LIGHT_BLUE='\e[94m'
export readonly LIGHT_CYAN='\e[96m'
export readonly LIGHT_GRAY='\e[37m'
export readonly LIGHT_GREEN='\e[92m'
export readonly LIGHT_MAGENTA='\e[95m'
export readonly LIGHT_RED='\e[91m'
export readonly LIGHT_YELLOW='\e[93m'

export readonly BLACK='\e[30m'
export readonly GRAY='\e[90m'
export readonly WHITE='\e[97m'

# Patina > Global Variables > Text Formatting > Text Style

export readonly BOLD='\e[1m'
export readonly UNDERLINE='\e[4m'

# Patina > Global Variables > Text Formatting > Reset

export readonly COLOR_DEFAULT='\e[39m'
export readonly COLOR_RESET='\e[0m'

# Patina > Global Variables > Patina Exceptions

PE0000='PE0000: Patina has encountered an unknown error.'
export readonly PE0000

PE0001='PE0001: Patina has not been given an expected argument.'
export readonly PE0001

PE0002='PE0002: Patina has been given too many arguments.'
export readonly PE0002

PE0003='PE0003: Patina has not been given a valid argument.'
export readonly PE0003

PE0004='PE0004: Patina cannot find the directory specified.'
export readonly PE0004

PE0005='PE0005: Patina cannot find the file specified.'
export readonly PE0005

PE0006='PE0006: Patina could not detect a required application.'
export readonly PE0006

PE0007='PE0007: Patina has not connected any components.'
export readonly PE0007

PE0008='PE0008: Patina does not have access to the Internet.'
export readonly PE0008

PE0009='PE0009: Patina cannot detect a valid version control repository.'
export readonly PE0009

PE0010='PE0010: Patina cannot access a required variable.'
export readonly PE0010

PE0011='PE0011: Patina cannot overwrite a pre-existing file.'
export readonly PE0011

PE0012='PE0012: Patina cannot overwrite a pre-existing directory.'
export readonly PE0012

PE0013='PE0013: Patina cannot execute this command under this environment.'
export readonly PE0013

PE0014='PE0014: Patina cannot perform current operation on a file.'
export readonly PE0014

PE0015='PE0015: Patina cannot perform current operation on a directory.'
export readonly PE0015

PE0016='PE0016: Patina cannot find the item specified.'
export readonly PE0016

PE0017='PE0017: Patina cannot perform current operation on item specified.'
export readonly PE0017

PE0018='PE0018: Patina cannot be initialized in an unsupported environment.'
export readonly PE0018

# Patina > Global Variables > Paths > Patina Root Directory

PATINA_PATH_ROOT="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
export readonly PATINA_PATH_ROOT

# Patina  > Global Variables > Paths > Patina Configuration

PATINA_PATH_CONFIGURATION="$HOME/.config/patina"
export readonly PATINA_PATH_CONFIGURATION

PATINA_FILE_CONFIGURATION="$PATINA_PATH_CONFIGURATION/patina.conf"
export readonly PATINA_FILE_CONFIGURATION

PATINA_FILE_SOURCE="${BASH_SOURCE[0]}"
export readonly PATINA_FILE_SOURCE

# Patina > Global Variables > Paths > Patina Components

PATINA_PATH_COMPONENTS="$PATINA_PATH_ROOT/components"
export readonly PATINA_PATH_COMPONENTS

PATINA_PATH_COMPONENTS_APPLICATIONS="$PATINA_PATH_COMPONENTS/applications"
export readonly PATINA_PATH_COMPONENTS_APPLICATIONS

PATINA_PATH_COMPONENTS_PLACES="$PATINA_PATH_COMPONENTS/places"
export readonly PATINA_PATH_COMPONENTS_PLACES

PATINA_PATH_COMPONENTS_SYSTEM="$PATINA_PATH_COMPONENTS/system"
export readonly PATINA_PATH_COMPONENTS_SYSTEM

PATINA_PATH_COMPONENTS_USER="$PATINA_PATH_COMPONENTS/user"
export readonly PATINA_PATH_COMPONENTS_USER

# Patina > Global Variables > Paths > System Files

export readonly SYSTEM_OS_RELEASE='/etc/os-release'
export readonly SYSTEM_LSB_RELEASE='/etc/lsb-release'

#############
# Functions #
#############

patina_initialize() {
  # Ensure Patina is operating inside of a GNU/Linux environment.
  if [ "$OSTYPE" != 'linux-gnu' ] ; then
    patina_raise_exception 'PE0018'
    return 1
  fi

  # Import additional system variables.
  if [ -f "$SYSTEM_OS_RELEASE" ] ; then source "$SYSTEM_OS_RELEASE" ; fi
  if [ -f "$SYSTEM_LSB_RELEASE" ] ; then source "$SYSTEM_LSB_RELEASE" ; fi

  # Create Patina Directory Structure.
  mkdir -p "$PATINA_PATH_CONFIGURATION"
  mkdir -p "$PATINA_PATH_COMPONENTS"/{applications,places,system,user}

  # Success: Connect and apply Patina configuration.
  if [ -f "$PATINA_FILE_CONFIGURATION" ] ; then
    chmod a-x "$PATINA_FILE_CONFIGURATION"
    source "$PATINA_FILE_CONFIGURATION"

  # Failure: Configuration file does not exist.
  else
    patina_create_configuration_file
  fi

  # Connect all detected Patina components.
  for component in \
    "$PATINA_PATH_COMPONENTS"/{applications,places,system,user}/patina_*.sh ; do
    if [ -f "$component" ] ; then
      source "$component"
      patina_components_list+=("${component}")
    fi
  done

  # Lock variables after Patina is successfully loaded.
  readonly -a patina_components_list
  readonly TERM="$TERM"
  readonly OSTYPE="$OSTYPE"

  # Display main Patina author/copyright header.
  echo_wrap "${PATINA_MAJOR_COLOR}Patina ${PATINA_VERSION} '${PATINA_CODENAME}' / BASH ${BASH_VERSION%%[^0-9.]*}${COLOR_RESET}"
  echo_wrap "${PATINA_MAJOR_COLOR}Copyright (C) 2019 William Whinn${COLOR_RESET}"
  echo_wrap "${PATINA_MINOR_COLOR}$PATINA_URL${COLOR_RESET}\n"

  # Finally: Garbage collection.
  unset -f "${FUNCNAME[0]}"

  return 0
}

patina_create_configuration_file() {
  # Default configuration options listed here.
  echo 'PATINA_THEME=default' > "$PATINA_FILE_CONFIGURATION"

  # Refresh the terminal to load new configuration.
  patina_terminal_refresh

  return 0
}

patina_show_component_report() {
  # Failure: Success condition(s) not met.
  if [ "$#" -ge 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Patina Component(s) detected.
  elif [[ -n "${patina_components_list[*]}" ]] ; then
    # Display Header
    echo
    echo_wrap "${BOLD}Patina Component Report${COLOR_RESET}\\n"
    echo_wrap "Patina has connected the following ${#patina_components_list[@]} component(s):\\n"

    # Success: 'tree' is installed. Display enhanced component list.
    if ( command -v 'tree' > /dev/null 2>&1 ) ; then
      tree --sort=name --dirsfirst --noreport --prune -P patina_*.sh "$PATINA_PATH_COMPONENTS"
      echo
      return 0

    # Success: 'tree' is not installed. Display standard component list.
    else
      for component in "${patina_components_list[@]}" ; do
        echo_wrap "$(basename "$component")"
      done

      echo
      return 0
    fi

  # Failure: Patina Component(s) were not detected.
  else
    patina_raise_exception 'PE0007'
    return 1
  fi
}

patina_show_dependency_report() {
  # Display Header.
  echo
  echo_wrap "${BOLD}Patina Dependency Report${COLOR_RESET}\\n"

  echo_wrap "${BOLD}NOTE${COLOR_RESET} Distribution-Native Packages Detected Only.\\n"

  # Display table header.
  echo_wrap "${BOLD}PACKAGE\\t\\tCOMMAND\\t\\tSTATE${COLOR_RESET}"

  printf "clamav\\t\\tp-clamscan"
  if ( command -v 'clamscan' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t${light_green}Installed${COLOR_RESET}"
  else
    echo_wrap "\\t${light_red}Not Installed${COLOR_RESET}"
  fi

  printf "genisoimage\tp-iso"
  if ( command -v 'mkisofs' > /dev/null 2>&1 ) ; then
    echo_wrap "\t\t${light_green}Installed${COLOR_RESET}"
  else
    echo_wrap "\t\t${light_red}Not Installed${COLOR_RESET}"
  fi

  printf "git\\t\\tp-update"
  if ( command -v 'git' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t${light_green}Installed${COLOR_RESET}"
  else
    echo_wrap "\\t${light_red}Not Installed${COLOR_RESET}"
  fi

  printf "gnupg2\\t\\tp-gpg"
  if ( command -v 'gpg' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t\\t${light_green}Installed${COLOR_RESET}"
  else
    echo_wrap "\\t\\t${light_red}Not Installed${COLOR_RESET}"
  fi

  printf "libreoffice\\tp-pdf"
  if ( command -v 'soffice' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t\\t${light_green}Installed${COLOR_RESET}"
  else
    echo_wrap "\\t\\t${light_red}Not Installed${COLOR_RESET}"
  fi

  printf "timeshift\\tp-timeshift"
  if ( command -v 'timeshift' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t${light_green}Installed${COLOR_RESET}"
  else
    echo_wrap "\\t${light_red}Not Installed${COLOR_RESET}"
  fi

  printf "tree\\t\\tp-list"
  if ( command -v 'tree' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t\\t${light_green}Installed${COLOR_RESET}"
  else
    echo_wrap "\\t\\t${light_red}Not Installed${COLOR_RESET}"
  fi

  printf "ufw\\t\\tp-ufw"
  if ( command -v 'ufw' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t\\t${light_green}Installed${COLOR_RESET}"
  else
    echo_wrap "\\t\\t${light_red}Not Installed${COLOR_RESET}"
  fi

  echo
  return 0
}

patina_show_system_report() {
  # Failure: Patina has been given too many arguments.
  if [ "$#" -ge 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Display the Patina System Report.
  elif [ "$#" -eq 0 ] ; then
    # Display Header
    echo
    echo_wrap "${BOLD}Patina System Report${COLOR_RESET}\\n"

    # Show System Report
    echo_wrap "${BOLD}Operating System${COLOR_RESET}\\t$PRETTY_NAME"
    echo_wrap "${BOLD}Operating System URL${COLOR_RESET}\\t<$HOME_URL>"
    echo_wrap "${BOLD}Current Session${COLOR_RESET}\\t\\t$XDG_CURRENT_DESKTOP ($XDG_SESSION_TYPE)"
    echo_wrap "${BOLD}Linux Kernel Version${COLOR_RESET}\\t$(uname -r)"
    echo_wrap "${BOLD}Package Manager${COLOR_RESET}\\t\\t$(to_upper "${PATINA_PACKAGE_MANAGER}")"
    echo_wrap "${BOLD}BASH Version${COLOR_RESET}\\t\\t${BASH_VERSION%%[^0-9.]*}"

    echo
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

patina_raise_exception() {
  # Failure: Patina has not been given an argument.
  if [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Display Patina Exception.
  elif [[ "$1" =~ [P][E][0-9][0-9][0-9][0-9] ]] ; then
    echo_wrap "${RED}${!1}${COLOR_RESET}"
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

patina_open_folder() {
  # Failure: Patina has not been given an argument.
  if [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 2 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Failure: Target is a file.
  elif [ -f "$1" ] ; then
    patina_raise_exception 'PE0014'
    return 1

  # Failure: Target directory does not exist
  elif [ ! -d "$1" ] ; then
    patina_raise_exception 'PE0004'
    return 1

  # Success: Change directory.
  elif [ -d "$1" ] && [ -z "$2" ] ; then
    cd "$1" || return
    return 0

  # Success: Change directory and open in graphical File Manager if possible.
  elif [ -d "$1" ] && [ "$2" ] ; then
    case "$2" in
      "-g")
        # Success: Open location graphically.
        if ( command -v 'xdg-open' > /dev/null 2>&1 ) ; then
          cd "$1" || return
          xdg-open "$(pwd)" > /dev/null 2>&1
          return 0
        else
          # Failure: Cannot open location graphically.
          patina_raise_exception 'PE0013'
          return 1
        fi
        ;;
      *)
        patina_raise_exception 'PE0003'
        return 1
        ;;
    esac

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

patina_open_folder_graphically() {
  # Success: No argument provided, attempt to open Home folder graphically.
  if [ "$#" -eq 0 ] ; then
    patina_open_folder "$HOME" -g
    return 0

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Argument provided, attempt to open given folder graphically.
  elif [ "$#" -eq 1 ] ; then
    patina_open_folder "$1" -g
    return 0

  # Failure: Catch All.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

generate_date_stamp() { date --utc +%Y%m%dT%H%M%SZ ; return 0 ; }

echo_wrap() {
  # Failure: Patina has not been given an argument.
  if [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Display wrapped text.
  elif [ -n "$1" ] ; then
    (echo -e "$1") | fmt -w "$(tput cols)"
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

to_lower() {
  # Failure: Patina has not been given an argument.
  if [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Display text as lower-case.
  elif [ -n "$1" ] ; then
    echo -e "$1" | tr '[:upper:]' '[:lower:]'
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

to_upper() {
  # Failure: Patina has not been given an argument.
  if [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Display text as upper-case.
  elif [ -n "$1" ] ; then
    echo -e "$1" | tr '[:lower:]' '[:upper:]'
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

bold() {
  # Failure: Patina has not been given an argument.
  if [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1
  # Success: Display text as upper-case.
  elif [ -n "$1" ] ; then
    echo_wrap "${BOLD}$1${COLOR_RESET}"
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

underline() {
  # Failure: Patina has not been given an argument.
  if [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1
  # Success: Display text as upper-case.
  elif [ -n "$1" ] ; then
    echo_wrap "${UNDERLINE}$1${COLOR_RESET}"
    return 0

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

generate_uuid() {
  local label_command_6="head /dev/urandom | tr -dc A-Za-z0-9 | head -c6"
  local label_command_4="head /dev/urandom | tr -dc A-Za-z0-9 | head -c4"

  echo -e "$(eval "$label_command_6"; printf '-'; eval "$label_command_4"; \
    printf '-'; eval "$label_command_4"; printf '-'; eval "$label_command_4"; \
    printf '-'; eval "$label_command_4"; printf '-'; eval "$label_command_4"; \
    printf '-'; eval "$label_command_6"; )"

  return 0
}

patina_terminal_refresh() {
  cd || return 1
  clear
  reset
  exec bash
}

patina_terminal_reset() {
  cd || return 1
  clear
  history -c
  true > ~/.bash_history
  reset
  exec bash
}

###########
# Exports #
###########

export -f 'echo_wrap'
export -f 'generate_date_stamp'
export -f 'patina_raise_exception'
export -f 'to_lower'
export -f 'to_upper'
export -f 'generate_uuid'

###########
# Aliases #
###########

# Patina > Aliases > Help Commands

alias 'p-help'='less $PATINA_PATH_ROOT/README.md'

# Patina > Aliases > System Report Commands

alias 'p-deps'='patina_show_dependency_report'
alias 'p-list'='patina_show_component_report'
alias 'p-system'='patina_show_system_report'

# Patina > Aliases > Terminal Reset Commands

alias 'p-refresh'='patina_terminal_refresh'
alias 'p-reset'='patina_terminal_reset'

# Patina > Aliases > File Manager Commands

alias 'files'='patina_open_folder_graphically'
alias 'p-root'='patina_open_folder $PATINA_PATH_ROOT'

# Patina > Aliases > Component Location Commands

alias 'p-c'='patina_open_folder $PATINA_PATH_COMPONENTS'
alias 'p-c-applications'='patina_open_folder $PATINA_PATH_COMPONENTS_APPLICATIONS'
alias 'p-c-places'='patina_open_folder $PATINA_PATH_COMPONENTS_PLACES'
alias 'p-c-system'='patina_open_folder $PATINA_PATH_COMPONENTS_SYSTEM'
alias 'p-c-user'='patina_open_folder $PATINA_PATH_COMPONENTS_USER'

# Patina > Aliases > String Generator Commands

alias 'p-uuid'='generate_uuid'

#############
# Kickstart #
#############

patina_initialize

# End of File.
