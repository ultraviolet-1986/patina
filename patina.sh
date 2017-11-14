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
readonly patina_metadata_version='0.6.5'
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

    # Set initial Patina variables
    patina_has_internet=''

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

# Functions / Networking

patina_detect_internet_connection() {
  if ( ping -c 1 8.8.8.8 ) &> /dev/null ; then
    patina_has_internet='true'
  else
    patina_has_internet='false'
  fi
}

# Functions / Places

patina_open_folder() {
  # Failure: Package 'xdg-utils' is not installed
  if ( ! hash 'xdg-open' ) ; then
    echo_wrap "\\nCannot resolve path because package ${patina_major_color}xdg-utils${color_reset} is not installed.\\n"

  # Failure: A path has not been supplied
  elif [ "$#" -eq "0" ] ; then
    cd || return
    xdg-open "$(pwd)" > /dev/null 2>&1

  # Success: A path was supplied and it exists
  elif [ -d "$1" ] ; then
    cd "$1" || return
    xdg-open "$(pwd)" > /dev/null 2>&1

  # Failure: Catch any other error condition here
  else
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot open the location because the path to directory ${patina_minor_color}$1${color_reset} was invalid or does not exist.\\n"
  fi
}

patina_open_file() {
  # Failure: Package 'xdg-utils' not installed
  if ( ! hash 'xdg-open' ) ; then
    echo_wrap "\\nCannot resolve path because package ${patina_major_color}xdg-utils${color_reset} is not installed.\\n"

  # Failure: An argument was not supplied
  elif [ "$#" -eq "0" ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot open the file because a path was not specified.\\n"

  # Success: File exists
  elif [ -f "$1" ] ; then
    local file_location=''
    file_location=$(dirname "${1}")
    cd "$file_location" || return
    xdg-open "$1" > /dev/null 2>&1
    unset file_location

  # Failure: Catch any other error condition here
  else
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot open the location because the path to file ${patina_minor_color}$1${color_reset} was invalid or does not exist.\\n"
  fi
}

patina_open_url() {
  patina_detect_internet_connection

  # Failure: Package 'xdg-utils' not installed
  if ( ! hash 'xdg-open' ) ; then
    echo_wrap "\\nCannot resolve path because package ${patina_major_color}xdg-utils${color_reset} is not installed.\\n"

  # Failure: An argument was not specified
  elif [ "$#" -eq "0" ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot open the URL because a link was not specified.\\n"

  # Failure: Patina is not connected to the internet
  elif [ "$patina_has_internet" = 'false' ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} is ${patina_minor_color}not connected${color_reset} to the Internet.\\n"

  # Success: URL exists
  elif [ "$1" ] ; then
    echo_wrap "\\nThe URL ${patina_minor_color}$1${color_reset} has been sent to the default web browser.\\n"
    xdg-open "$1" > /dev/null 2>&1

  # Failure: Catch any other error condition here
  else
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot open the location because the URL ${patina_minor_color}$1${color_reset} was invalid or does not exist.\\n"
  fi
}

# Functions / Text

echo_wrap() { (echo -e "$1") | fmt -w "$(tput cols)" ; }

###########
# Exports #
###########

export -f 'echo_wrap'

###########
# Aliases #
###########

# Patina
alias 'p-list'='patina_list_connected_components'
alias 'p-refresh'='patina_terminal_refresh'
alias 'p-reset'='patina_terminal_reset'

# Places / Folders
alias 'files'='patina_open_folder'
alias 'p-root'='patina_open_folder $patina_path_root'

# Places / Components
alias 'p-c'='patina_open_folder $patina_path_components'
alias 'p-c-applications'='patina_open_folder $patina_path_components_applications'
alias 'p-c-places'='patina_open_folder $patina_path_components_places'
alias 'p-c-system'='patina_open_folder $patina_path_components_system'
alias 'p-c-user'='patina_open_folder $patina_path_components_user'

# Places / Files
alias 'p-source'='patina_open_file $patina_file_source'
alias 'p-config'='patina_open_file $patina_file_configuration'

# Places / URLs
alias 'p-url-patina'='patina_open_url $patina_metadata_url'

# Theme / Colors
alias 'p-theme'='patina_theme_apply'

# Theme / Prompts
alias 'p-prompt'='patina_prompt_apply'

#############
# Kickstart #
#############

patina_start

# End of File.
