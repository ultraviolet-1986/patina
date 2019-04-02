#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2019 William Willis Whinn

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

# Patina / Core / Metadata
readonly patina_metadata_version='0.7.5'
readonly patina_metadata_codename='Duchess'
readonly patina_metadata_url='https://github.com/ultraviolet-1986/patina'

# Patina / Core / Exceptions
export readonly PE0000='PE0000: Patina has encountered an unknown error.'
export readonly PE0001='PE0001: Patina has not been given an expected argument.'
export readonly PE0002='PE0002: Patina has been given too many arguments.'
export readonly PE0003='PE0003: Patina has not been given a valid argument.'
export readonly PE0004='PE0004: Patina cannot find the directory specified.'
export readonly PE0005='PE0005: Patina cannot find the file specified.'
export readonly PE0006='PE0006: Patina could not detect a required application.'
export readonly PE0007='PE0007: Patina has not connected any components.'
export readonly PE0008='PE0008: Patina does not have access to the Internet.'
export readonly PE0009='PE0009: Patina cannot detect a valid source control repository.'
export readonly PE0010='PE0010: Patina cannot access a required variable.'

# Patina / Paths / Root
readonly patina_path_root="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
readonly patina_path_components="$patina_path_root/components"
readonly patina_path_resources="$patina_path_root/resources"

# Patina / Paths / Configuration
readonly patina_path_configuration="$HOME/.config/patina"
readonly patina_file_configuration="$patina_path_configuration/patina.conf"
readonly patina_file_source="${BASH_SOURCE[0]}"

# Patina / Paths / Components
readonly patina_path_components_applications="$patina_path_components/applications"
readonly patina_path_components_places="$patina_path_components/places"
readonly patina_path_components_system="$patina_path_components/system"
readonly patina_path_components_user="$patina_path_components/user"

# Patina / Paths / Resources
readonly patina_path_resources_help="$patina_path_resources/help"

# Patina / Paths / System / Files
readonly system_os_release='/etc/os-release'
readonly system_lsb_release='/etc/lsb-release'

#############
# Functions #
#############

patina_start() {
  # Ensure Patina is operating inside of a GNU/Linux environment
  if [ "$OSTYPE" != 'linux-gnu' ] ; then
    echo_wrap "Patina does not currently support your operating system. For more information, or to make a feature request, please visit '$patina_metadata_url'."
    return
  fi

  # Import additional system variables
  if [ -f "$system_os_release" ] ; then source "$system_os_release" ; fi
  if [ -f "$system_lsb_release" ] ; then source "$system_lsb_release" ; fi

  # Create Patina Directory Structure
  mkdir -p "$patina_path_configuration"
  mkdir -p "$patina_path_components"/{applications,places,system,user}
  mkdir -p "$patina_path_resources/help"

  # Success: Connect and apply Patina configuration
  if [ -f "$patina_file_configuration" ] ; then
    chmod a-x "$patina_file_configuration"
    source "$patina_file_configuration"

  # Failure: Configuration file does not exist
  else
    patina_create_configuration_file
  fi

  # Connect all detected Patina components
  for component in "$patina_path_components"/{applications,places,system,user}/patina_*.sh ; do
    if [ -f "$component" ] ; then
      chmod a-x "$component"
      source "$component"
      patina_components_list+=("${component}")
    fi
  done

  # Main Patina author/copyright header
  echo_wrap "${patina_major_color}Patina v${patina_metadata_version} '${patina_metadata_codename}' / BASH v${BASH_VERSION%%[^0-9.]*}${color_reset}"
  echo_wrap "${patina_major_color}Copyright (C) 2019 William Whinn${color_reset}"
  echo_wrap "${patina_minor_color}$patina_metadata_url${color_reset}\\n"

  # Lock variables after Patina is successfully loaded
  readonly -a patina_components_list
  readonly TERM="$TERM"
  readonly OSTYPE="$OSTYPE"

  # Rubbish collection
  unset -f "${FUNCNAME[0]}"
}

patina_create_configuration_file() {
  # Default configuration options listed here.
  echo 'patina_theme=default' > "$patina_file_configuration"

  # Refresh the terminal to load new configuration
  patina_terminal_refresh
}

patina_list_connected_components() {
  # Failure: Success condition(s) not met.
  if [ "$#" -ge 1 ] ; then patina_throw_exception 'PE0002' ;

  # Success: Patina Component(s) detected.
  elif [[ -n "${patina_components_list[*]}" ]] ; then
    echo_wrap "\\nPatina has connected ${#patina_components_list[@]} component(s)${color_reset}\\n"

    for component in "${patina_components_list[@]}" ; do
      echo_wrap "$(find "$component" -print0 | xargs -0 basename)"
    done

    echo
    return

  # Failure: Patina Component(s) were not detected.
  else patina_throw_exception 'PE0007' ; fi
}

patina_throw_exception() {
  # Failure: Success condition(s) not met.
  if [ "$#" -eq "0" ] ; then patina_throw_exception 'PE0001' ;
  elif [ "$#" -gt 1 ] ; then patina_throw_exception 'PE0002' ;

  # Success: Display Patina Exception.
  elif [[ "$1" =~ [P][E][0-9][0-9][0-9][0-9] ]] ; then echo_wrap "${!1}" ; return ;

  # Failure: Catch All.
  else patina_throw_exception 'PE0000' ; fi
}

patina_open_folder() {
  # Failure: Success condition(s) not met.
  if ( ! hash 'xdg-open' ) ; then patina_throw_exception 'PE0006' ;
  elif [ "$#" -eq "0" ] ; then patina_throw_exception 'PE0001' ;
  elif [ "$#" -gt 2 ] ; then patina_throw_exception 'PE0002' ;
  elif [ -n "$2" ] && [ "$2" != '-g' ] ; then patina_throw_exception 'PE0003' ;
  elif [ -f "$1" ] ; then patina_throw_exception 'PE0003' ;
  elif [ ! -d "$1" ] ; then patina_throw_exception 'PE0004' ;

  # Success: Change directory and open in File Manager.
  elif [ -d "$1" ] && [ "$2" = '-g' ] ; then cd "$1" || return ; xdg-open "$(pwd)" > /dev/null 2>&1 ; return ;

  # Success: Change Directory.
  elif [ -d "$1" ] ; then cd "$1" || return ; return ;

  # Failure: Catch All.
  else patina_throw_exception 'PE0000' ; fi
}

patina_open_folder_graphically() {
  # Success: Open Home folder graphically in the absence of an agrument.
  if [ "$#" -eq "0" ] ; then ; patina_open_folder "$HOME" -g ; return ;

  # Failure: Success condition(s) not met.
  elif [ "$#" -gt 1 ] ; then patina_throw_exception 'PE0002' ;
  elif [ -f "$1" ] ; then patina_throw_exception 'PE0003' ;
  elif [ ! -d "$1" ] ; then patina_throw_exception 'PE0004' ;

  # Success: Open folder graphically.
  elif [ -d "$1" ] ; then patina_open_folder "$1" -g ; return ;

  # Failure: Catch All.
  else patina_throw_exception 'PE0000' ; fi
}

echo_wrap() {
  # Failure: Success condition(s) not met.
  if [ "$#" -eq "0" ] ; then patina_throw_exception 'PE0001' ;
  elif [ "$#" -gt 1 ] ; then patina_throw_exception 'PE0002' ;

  # Success: Display wrapped text.
  elif [ -n "$1" ] ; then (echo -e "$1") | fmt -w "$(tput cols)" ;

  # Failure: Catch All.
  else patina_throw_exception 'PE0000' ; fi
}

to_lower() {
  # Failure: Success condition(s) not met.
  if [ "$#" -eq "0" ] ; then patina_throw_exception 'PE0001' ;
  elif [ "$#" -gt 1 ] ; then patina_throw_exception 'PE0002' ;

  # Success: Display text as lower-case.
  elif [ -n "$1" ] ; then echo -e "$1" | tr '[:upper:]' '[:lower:]' ; return ;

  # Failure: Catch All.
  else patina_throw_exception 'PE0000' ; fi
}

to_upper() {
  # Failure: Success condition(s) not met.
  if [ "$#" -eq "0" ] ; then patina_throw_exception 'PE0001' ;
  elif [ "$#" -gt 1 ] ; then patina_throw_exception 'PE0002' ;

  # Success: Display text as upper-case.
  elif [ -n "$1" ] ; then echo -e "$1" | tr '[:lower:]' '[:upper:]' ; return ;

  # Failure: Catch All.
  else patina_throw_exception 'PE0000' ; fi
}

patina_terminal_refresh() {
  cd || return
  clear
  reset
  exec bash
}

patina_terminal_reset() {
  cd || return
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
export -f 'patina_throw_exception'
export -f 'to_lower'
export -f 'to_upper'

###########
# Aliases #
###########

# Patina / Core
alias 'p-help'='less $patina_path_root/README.md'

alias 'p-list'='patina_list_connected_components'

alias 'p-refresh'='patina_terminal_refresh'
alias 'p-reset'='patina_terminal_reset'

# Patina / Places / Folders
alias 'files'='patina_open_folder_graphically'
alias 'p-root'='patina_open_folder $patina_path_root'

# Patina / Places / Components
alias 'p-c'='patina_open_folder $patina_path_components'
alias 'p-c-applications'='patina_open_folder $patina_path_components_applications'
alias 'p-c-places'='patina_open_folder $patina_path_components_places'
alias 'p-c-system'='patina_open_folder $patina_path_components_system'
alias 'p-c-user'='patina_open_folder $patina_path_components_user'

# Patina / Places / Resources
alias 'p-r'='patina_open_folder $patina_path_resources'
alias 'p-r-help'='patina_open_folder $patina_path_resources_help'

#############
# Kickstart #
#############

patina_start

# End of File.
