#!/usr/bin/env bash

###########
# License #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2022 William Willis Whinn

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

#############
# Variables #
#############

declare -r PATINA_VERSION='1.0.1'
declare -r PATINA_CODENAME='Mae'
declare -r PATINA_URL='https://github.com/ultraviolet-1986/patina'

# Text Formatting

declare -rx BLUE='\e[34m'
declare -rx CYAN='\e[36m'
declare -rx GREEN='\e[32m'
declare -rx MAGENTA='\e[35m'
declare -rx ORANGE='\e[38;5;130m'
declare -rx RED='\e[31m'
declare -rx TEAL='\e[38;5;29m'
declare -rx YELLOW='\e[33m'

declare -rx LIGHT_BLUE='\e[94m'
declare -rx LIGHT_CYAN='\e[96m'
declare -rx LIGHT_GRAY='\e[37m'
declare -rx LIGHT_GREEN='\e[92m'
declare -rx LIGHT_MAGENTA='\e[95m'
declare -rx LIGHT_ORANGE='\e[38;5;202m'
declare -rx LIGHT_RED='\e[91m'
declare -rx LIGHT_TEAL='\e[38;5;35m'
declare -rx LIGHT_YELLOW='\e[93m'

declare -rx BLACK='\e[30m'
declare -rx GRAY='\e[90m'
declare -rx WHITE='\e[97m'

declare -rx BOLD='\e[1m'
declare -rx ITALIC='\e[3m'
declare -rx STRIKETHROUGH='\e[9m'
declare -rx UNDERLINE='\e[4m'

declare -rx COLOR_DEFAULT='\e[39m'
declare -rx COLOR_RESET='\e[0m'

# Patina Exceptions

declare -rx PE0000='PE0000: Patina has encountered an unknown error.'
declare -rx PE0001='PE0001: Patina has not been given an expected argument.'
declare -rx PE0002='PE0002: Patina has been given too many arguments.'
declare -rx PE0003='PE0003: Patina has not been given a valid argument.'
declare -rx PE0004='PE0004: Patina cannot find the directory specified.'
declare -rx PE0005='PE0005: Patina cannot find the file specified.'
declare -rx PE0006='PE0006: Patina could not detect a required application.'
declare -rx PE0007='PE0007: Patina has not connected any components.'
declare -rx PE0008='PE0008: Patina does not have access to the Internet.'
declare -rx PE0009='PE0009: Patina cannot detect a valid version control repository.'
declare -rx PE0010='PE0010: Patina cannot access a required variable.'
declare -rx PE0011='PE0011: Patina cannot overwrite a pre-existing file.'
declare -rx PE0012='PE0012: Patina cannot overwrite a pre-existing directory.'
declare -rx PE0013='PE0013: Patina cannot execute this command under this environment.'
declare -rx PE0014='PE0014: Patina cannot perform operation on a file.'
declare -rx PE0015='PE0015: Patina cannot perform operation on a directory.'
declare -rx PE0016='PE0016: Patina cannot find the item specified.'
declare -rx PE0017='PE0017: Patina cannot perform operation on item specified.'
declare -rx PE0018='PE0018: Patina cannot be initialized in an unsupported environment.'
declare -rx PE0019='PE0019: Patina cannot perform operation on empty directory.'

# Paths

declare -rx SYSTEM_OS_RELEASE='/etc/os-release'
declare -rx SYSTEM_LSB_RELEASE='/etc/lsb-release'

PATINA_PATH_ROOT="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
readonly PATINA_PATH_ROOT
export PATINA_PATH_ROOT

PATINA_PATH_CONFIGURATION="${HOME}/.config/patina"
readonly PATINA_PATH_CONFIGURATION
export PATINA_PATH_CONFIGURATION

PATINA_FILE_CONFIGURATION="${PATINA_PATH_CONFIGURATION}/patina.conf"
readonly PATINA_FILE_CONFIGURATION
export PATINA_FILE_CONFIGURATION

PATINA_FILE_SOURCE="${BASH_SOURCE[0]}"
readonly PATINA_FILE_SOURCE
export PATINA_FILE_SOURCE

PATINA_PATH_COMPONENTS="${PATINA_PATH_ROOT}/components"
readonly PATINA_PATH_COMPONENTS
export PATINA_PATH_COMPONENTS

PATINA_PATH_COMPONENTS_APPLICATIONS="${PATINA_PATH_COMPONENTS}/applications"
readonly PATINA_PATH_COMPONENTS_APPLICATIONS
export PATINA_PATH_COMPONENTS_APPLICATIONS

PATINA_PATH_COMPONENTS_PLACES="${PATINA_PATH_COMPONENTS}/places"
readonly PATINA_PATH_COMPONENTS_PLACES
export PATINA_PATH_COMPONENTS_PLACES

PATINA_PATH_COMPONENTS_SYSTEM="${PATINA_PATH_COMPONENTS}/system"
readonly PATINA_PATH_COMPONENTS_SYSTEM
export PATINA_PATH_COMPONENTS_SYSTEM

PATINA_PATH_COMPONENTS_USER="${PATINA_PATH_COMPONENTS}/user"
readonly PATINA_PATH_COMPONENTS_USER
export PATINA_PATH_COMPONENTS_USER

#############
# Functions #
#############

# shellcheck source=/dev/null
patina_initialize() {

  if [ "${OSTYPE}" != 'linux-gnu' ] ; then
    patina_raise_exception 'PE0018'
    return 1
  fi

  export TERM=xterm-256color

  if [ -f "${SYSTEM_OS_RELEASE}" ] ; then
    . "${SYSTEM_OS_RELEASE}"
  fi

  if [ -f "${SYSTEM_LSB_RELEASE}" ] ; then
    . "${SYSTEM_LSB_RELEASE}"
  fi

  if [[ ! "${PATH}" == *"${HOME}/bin"* ]]; then
    if [ -d "${HOME}/bin" ] ; then
        PATH="${HOME}/bin:${PATH}"
    fi
  fi

  mkdir -p "${PATINA_PATH_CONFIGURATION}"
  mkdir -p "${PATINA_PATH_COMPONENTS}"/{applications,places,system,user}

  if [ -f "${PATINA_FILE_CONFIGURATION}" ] ; then
    chmod a-x "${PATINA_FILE_CONFIGURATION}"
    . "${PATINA_FILE_CONFIGURATION}"
  else
    patina_create_configuration_file
  fi

  for component in "${PATINA_PATH_COMPONENTS}"/{applications,places,system,user}/patina_*.sh ; do
    if [ -f "${component}" ] ; then
      chmod a-x "${component}"
      . "${component}"
      patina_components_list+=("${component}")
    fi
  done

  readonly -a patina_components_list
  readonly TERM="${TERM}"
  readonly OSTYPE="${OSTYPE}"

  clear
  printf "${PATINA_MAJOR_COLOR}Patina %s '%s' / " "${PATINA_VERSION}" "${PATINA_CODENAME}"
  echo -e "BASH ${BASH_VERSION%%[^0-9.]*}${COLOR_RESET}"
  echo -e "${PATINA_MAJOR_COLOR}Copyright (C) 2022 William Whinn${COLOR_RESET}"
  echo -e "${PATINA_MINOR_COLOR}${PATINA_URL}${COLOR_RESET}\\n"

  unset -f "${FUNCNAME[0]}"

  return 0
}

patina_create_configuration_file() {
  echo 'PATINA_THEME=default' > "${PATINA_FILE_CONFIGURATION}"

  patina_terminal_refresh

  return 0
}

patina_raise_exception() {
  if [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1
  elif [[ "$1" =~ [P][E][0-9][0-9][0-9][0-9] ]] ; then
    echo_wrap "${RED}${!1}${COLOR_RESET}"
    return 0
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

patina_required_software(){
  if [ "$#" -eq 0 ]; then
    patina_raise_exception 'PE0001'
    return 1
  elif [ "$#" -gt 2 ]; then
    patina_raise_exception 'PE0002'
    return 1
  elif [ "$#" -eq 2 ]; then
    echo_wrap "${YELLOW}NOTE: Patina requires command '$1' from package '$2'.${COLOR_RESET}"
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

patina_open_folder() {
  if [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1
  elif [ "$#" -gt 2 ] ; then
    patina_raise_exception 'PE0002'
    return 1
  elif [ -f "$1" ] ; then
    patina_raise_exception 'PE0014'
    return 1
  elif [ ! -d "$1" ] ; then
    patina_raise_exception 'PE0004'
    return 1
  elif [ -d "$1" ] && [ -z "$2" ] ; then
    cd "$1" || return 1
    return 0
  elif [ -d "$1" ] && [ "$2" ] ; then
    case "$2" in
      "-g")
        if ( command -v 'xdg-open' > /dev/null 2>&1 ) ; then
          cd "$1" || return 1
          xdg-open "$( pwd )" > /dev/null 2>&1
          return 0
        else
          patina_raise_exception 'PE0013'
          return 1
        fi
        ;;
      *)
        patina_raise_exception 'PE0003'
        return 1
        ;;
    esac
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

patina_open_folder_graphically() {
  if [ "$#" -eq 0 ] ; then
    patina_open_folder "${HOME}" -g
    return 0
  elif [ "$#" -gt 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1
  elif [ "$#" -eq 1 ] ; then
    patina_open_folder "$1" -g
    return 0
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

echo_wrap() {
  ( echo -e "$@" ) | fmt -w "$( tput cols )"
  return 0
}

to_lower() {
  echo_wrap "$@" | tr '[:upper:]' '[:lower:]'
  return 0
}

to_upper() {
  echo_wrap "$@" | tr '[:lower:]' '[:upper:]'
   return 0
}

bold() {
  echo_wrap "${BOLD}$*${COLOR_RESET}"
  return 0
}

underline() {
  echo_wrap "${UNDERLINE}$*${COLOR_RESET}"
  return 0
}

italic() {
  echo_wrap "${ITALIC}$*${COLOR_RESET}"
  return 0
}

strikethrough() {
  echo_wrap "${STRIKETHROUGH}$*${COLOR_RESET}"
  return 0
}

generate_date_stamp() {
  date --utc +%Y%m%dT%H%M%SZ
  return 0
}

generate_uuid() {
  local label_command_6="head /dev/urandom | tr -dc A-Za-z0-9 | head -c6"
  local label_command_4="head /dev/urandom | tr -dc A-Za-z0-9 | head -c4"

  echo -e "$( eval "${label_command_6}" ; printf '-' ; eval "${label_command_4}" ; printf '-' ; \
  eval "${label_command_4}" ; printf '-' ; eval "${label_command_4}" ; printf '-' ; \
  eval "${label_command_4}" ; printf '-' ; eval "${label_command_4}" ; printf '-' ; \
  eval "${label_command_6}" ; )"

  return 0
}

generate_volume_label() {
  local label_command="head /dev/urandom | tr -dc A-Za-z0-9 | head -c4 | tr '[:lower:]' '[:upper:]'"
  echo -e "$(eval "${label_command}" ; printf "-" ; eval "${label_command}")"

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

export -f 'patina_raise_exception'

export -f 'echo_wrap'

export -f 'to_lower'
export -f 'to_upper'

export -f 'bold'
export -f 'italic'
export -f 'strikethrough'
export -f 'underline'

export -f 'generate_date_stamp'
export -f 'generate_uuid'
export -f 'generate_volume_label'

###########
# Aliases #
###########

alias 'p-changes'='less "${PATINA_PATH_ROOT}/CHANGELOG.md"'
alias 'p-help'='less "${PATINA_PATH_ROOT}/README.md"'

alias 'p-refresh'='patina_terminal_refresh'
alias 'p-reset'='patina_terminal_reset'

alias 'files'='patina_open_folder_graphically'
alias 'p-root'='patina_open_folder "${PATINA_PATH_ROOT}"'

alias 'p-c'='patina_open_folder "${PATINA_PATH_COMPONENTS}"'
alias 'p-c-applications'='patina_open_folder "${PATINA_PATH_COMPONENTS_APPLICATIONS}"'
alias 'p-c-places'='patina_open_folder "${PATINA_PATH_COMPONENTS_PLACES}"'
alias 'p-c-system'='patina_open_folder "${PATINA_PATH_COMPONENTS_SYSTEM}"'
alias 'p-c-user'='patina_open_folder "${PATINA_PATH_COMPONENTS_USER}"'

alias 'p-date'='generate_date_stamp'
alias 'p-uuid'='generate_uuid'
alias 'p-vol'='generate_volume_label'

#############
# Kickstart #
#############

patina_initialize

# End of File.
