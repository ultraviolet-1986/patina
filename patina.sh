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
readonly patina_metadata_version_patch=1

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
  if [ "$OSTYPE" = 'linux-gnu' ] ; then
    # Create Patina Directory Structure
    mkdir -p "$patina_path_components"/{applications,places,system,user}
    mkdir -p "$patina_path_resources"/{exceptions,help}

    # Connect all detected Patina components
    for component in "$patina_path_components"/{applications,places,system,user}/patina_*.sh ; do
      if [ -f "$component" ] ; then
        chmod a-x "$component"
        source "$component"
        patina_components_list+=("${component}")
      fi
    done

    # Connect/create and apply Patina configuration
    if [ -f "$patina_file_configuration" ] ; then
      chmod a-x "$patina_file_configuration"

      # Connect configuration file
      source "$patina_file_configuration"

      if [ -z "$patina_theme" ] ; then
        # Failure: Rewrite preferences file and reset the console
        echo 'patina_theme=default' > "$patina_file_configuration"

        patina_terminal_refresh
      else
        # Success: Apply settings
        patina_theme_apply "$patina_theme"
      fi
    else
      # Create a new configuration file
      touch "$patina_file_configuration"

      # Populate the new configuration file with defaults
      echo 'patina_theme=default' > "$patina_file_configuration"

      patina_terminal_refresh
    fi

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

  else
    echo_wrap "Patina does not currently support your operating system. For "`
      `"more information, or to make a feature request, please visit "`
      `"'$patina_metadata_url'."
  fi

  # Rubbish collection
  unset -f "${FUNCNAME[0]}"
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

###########
# Exports #
###########

export -f 'echo_wrap'

###########
# Aliases #
###########

alias 'p-list'='patina_list_connected_components'

#############
# Kickstart #
#############

patina_start

# End of File.
