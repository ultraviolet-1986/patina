#!/usr/bin/env bash

##############
# Directives #
##############

# Components and configuration are not stored in a fixed location by design
# shellcheck source=/dev/null

# Some items are defined elsewhere
# shellcheck disable=SC2154

#############
# Variables #
#############

# Patina / Metadata
readonly patina_metadata_version_major=0
readonly patina_metadata_version_minor=7
readonly patina_metadata_version_patch=2

readonly patina_metadata_codename='Duchess'
readonly patina_metadata_url='https://github.com/ultraviolet-1986/patina'

# Patina / Root
readonly patina_path_root="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
readonly patina_path_components="$patina_path_root/components"
readonly patina_path_resources="$patina_path_root/resources"

# Patina / Components
readonly patina_path_components_applications="$patina_path_components/applications"
readonly patina_path_components_places="$patina_path_components/places"
readonly patina_path_components_system="$patina_path_components/system"
readonly patina_path_components_user="$patina_path_components/user"

# Patina / Resources
readonly patina_path_resources_exceptions="$patina_path_resources/exceptions"
readonly patina_path_resources_help="$patina_path_resources/help"

# Patina / Files
readonly patina_file_configuration="$HOME/.patinarc"
readonly patina_file_source="${BASH_SOURCE[0]}"

#############
# Functions #
#############

patina_start() {
  # Ensure Patina is operating inside of a GNU/Linux environment
  if [ "$OSTYPE" != 'linux-gnu' ] ; then
    echo_wrap "Patina does not currently support your operating system. For "`
      `"more information, or to make a feature request, please visit "`
      `"'$patina_metadata_url'."
    return
  fi

  # Create Patina Directory Structure
  mkdir -p "$patina_path_components"/{applications,places,system,user}
  mkdir -p "$patina_path_resources"/{exceptions,help}

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

  # Lock variables after Patina is successfully loaded
  readonly -a patina_components_list
  readonly TERM="$TERM"
  readonly OSTYPE="$OSTYPE"

  # Show Patina header / version information
  echo_wrap "${patina_major_color}Patina v"`
    `"$patina_metadata_version_major.$patina_metadata_version_minor."`
    `"$patina_metadata_version_patch '$patina_metadata_codename' / "`
    `"BASH v${BASH_VERSION%%[^0-9.]*}${color_reset}"
  echo_wrap "${patina_minor_color}$patina_metadata_url${color_reset}\\n"

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
  # Success: At least one component has been connected
  if [[ "${patina_components_list[*]}" ]] ; then
    echo_wrap "\\nPatina has connected ${#patina_components_list[@]} "`
      `"component(s)${color_reset}\\n"

    for component in "${patina_components_list[@]}" ; do
      echo_wrap "$(find "$component" -print0 | xargs -0 basename)"
    done

    echo

  # Failure: No components have been connected
  else
    patina_throw_exception 'PE0007'
  fi
}

patina_throw_exception() {
  if [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
  elif [ "$1" ] && [ ! -e "$patina_path_resources_exceptions/$1.txt" ] ; then
    patina_throw_exception 'PE0005'
  elif [[ "$1" =~ [P][E][0-9][0-9][0-9][0-9] ]] ; then
    echo_wrap "$1: $(cat "$patina_path_resources_exceptions"/"$1".txt)"
  else
    patina_throw_exception 'PE0000'
  fi
}

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

echo_wrap() {
  if [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
  elif [ "$1" ] ; then
    (echo -e "$1") | fmt -w "$(tput cols)"
  else
    patina_throw_exception 'PE0000'
  fi
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

###########
# Aliases #
###########

alias 'p-list'='patina_list_connected_components'

alias 'p-refresh'='patina_terminal_refresh'
alias 'p-reset'='patina_terminal_reset'

# Places / Folders
alias 'p-root'='patina_open_folder $patina_path_root'

# Places / Components
alias 'p-c'='patina_open_folder $patina_path_components'
alias 'p-c-applications'='patina_open_folder $patina_path_components_applications'
alias 'p-c-places'='patina_open_folder $patina_path_components_places'
alias 'p-c-system'='patina_open_folder $patina_path_components_system'
alias 'p-c-user'='patina_open_folder $patina_path_components_user'

# Places / Resources
alias 'p-r'='patina_open_folder $patina_path_resources'
alias 'p-r-exceptions'='patina_open_folder $patina_path_resources_exceptions'
alias 'p-r-help'='patina_open_folder $patina_path_resources_help'

#############
# Kickstart #
#############

patina_start

# End of File.
