#!/bin/bash

##############
# Directives #
##############

# Components and configuration are not stored in a fixed location by design
# shellcheck source=/dev/null

# Some variables are defined elsewhere
# shellcheck disable=SC2154

#############
# Variables #
#############

# Patina / Metadata
readonly patina_metadata_version='0.6.6'
readonly patina_metadata_codename='Kyrie'
readonly patina_metadata_url='https://github.com/ultraviolet-1986/patina'

# Patina / Root
readonly patina_path_root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly patina_path_components="$patina_path_root/components"

# Patina / Components
readonly patina_path_components_applications="$patina_path_components/applications"
readonly patina_path_components_places="$patina_path_components/places"
readonly patina_path_components_system="$patina_path_components/system"
readonly patina_path_components_user="$patina_path_components/user"

# Patina / Files
readonly patina_file_configuration="$patina_path_root/patina_configuration.conf"
readonly patina_file_source="$patina_path_root/patina.sh"

#############
# Functions #
#############

patina_start() {
  if [ "$OSTYPE" = 'linux-gnu' ] ; then
    # Set initial BASH variables
    debian_chroot="$debian_chroot"

    # Create Patina Directory Structure
    mkdir -p "$patina_path_components"/{applications,places,system,user}

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

      if [ -z "$patina_theme" ] || [ -z "$patina_prompt" ] ; then
        # Failure: Rewrite preferences file and reset the console
        echo 'patina_theme=default' > "$patina_file_configuration"
        echo 'patina_prompt=default' >> "$patina_file_configuration"

        patina_terminal_refresh
      else
        # Success: Apply settings
        patina_theme_apply "$patina_theme"
        patina_prompt_apply "$patina_prompt"
      fi
    else
      # Create a new configuration file
      touch "$patina_file_configuration"

      # Populate the new configuration file with defaults
      echo 'patina_theme=default' > "$patina_file_configuration"
      echo 'patina_prompt=default' >> "$patina_file_configuration"

      patina_terminal_refresh
    fi

    patina_detect_internet_connection

    # Lock variables after Patina is successfully loaded
    readonly -a patina_components_list
    readonly TERM="$TERM"
    readonly OSTYPE="$OSTYPE"

    # Show Patina header / version information
    echo_wrap "${patina_major_color}Patina v$patina_metadata_version '$patina_metadata_codename' / BASH v${BASH_VERSION%%[^0-9.]*}${color_reset}"
    echo_wrap "${patina_minor_color}$patina_metadata_url${color_reset}\\n"

  else
    echo_wrap "\\nPatina does not currently support your operating system. For more information, or to make a feature request, please visit '$patina_metadata_url'.\\n"
  fi

  # Rubbish collection
  unset -f "${FUNCNAME[0]}"
}

patina_list_connected_components() {
  # Success: At least one component has been connected
  if [[ "${patina_components_list[*]}" ]] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} has ${patina_major_color}${#patina_components_list[@]}${color_reset} connected component(s):\\n"

    for component in "${patina_components_list[@]}" ; do
      echo_wrap "$(find "$component" -print0 | xargs -0 basename)"
    done

    echo

  # Failure: No components have been connected
  else
    echo_wrap "\\n${patina_major_color}Patina${color_reset} has not connected any components.\\n"
  fi
}

echo_wrap() {
  (echo -e "$1") | fmt -w "$(tput cols)"
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
