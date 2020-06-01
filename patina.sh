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
# along with this program. If not, see <http://www.gnu.org/licenses/>.

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
readonly patina_metadata_version='0.7.8'
readonly patina_metadata_codename='Duchess'
readonly patina_metadata_url='https://github.com/ultraviolet-1986/patina'

# Patina / Text Formatting / Colors
export readonly blue='\e[34m'
export readonly cyan='\e[36m'
export readonly green='\e[32m'
export readonly magenta='\e[35m'
export readonly red='\e[31m'
export readonly yellow='\e[33m'
export readonly light_blue='\e[94m'
export readonly light_cyan='\e[96m'
export readonly light_gray='\e[37m'
export readonly light_green='\e[92m'
export readonly light_magenta='\e[95m'
export readonly light_red='\e[91m'
export readonly light_yellow='\e[93m'
export readonly black='\e[30m'
export readonly gray='\e[90m'
export readonly white='\e[97m'

# Patina / Text Formatting / Style
export readonly bold='\e[1m'
export readonly underline='\e[4m'

# Patina / Text Formatting / Reset
export readonly color_default='\e[39m'
export readonly color_reset='\e[0m'

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
export readonly PE0009='PE0009: Patina cannot detect a valid version control repository.'
export readonly PE0010='PE0010: Patina cannot access a required variable.'
export readonly PE0011='PE0011: Patina cannot overwrite a pre-existing file.'
export readonly PE0012='PE0012: Patina cannot overwrite a pre-existing directory.'
export readonly PE0013='PE0013: Patina cannot execute this command under this environment.'
export readonly PE0014='PE0014: Patina cannot perform current operation on a file.'
export readonly PE0015='PE0015: Patina cannot perform current operation on a directory.'
export readonly PE0016='PE0016: Patina cannot find the item specified.'
export readonly PE0017='PE0017: Patina cannot perform current operation on item specified.'
export readonly PE0018='PE0018: Patina cannot be initialized in an unsupported environment.'

# Patina / Paths / Root
patina_path_root="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
export readonly patina_path_root

# Patina / Paths / Configuration
export readonly patina_path_configuration="$HOME/.config/patina"
export readonly patina_file_configuration="$patina_path_configuration/patina.conf"
export readonly patina_file_source="${BASH_SOURCE[0]}"

# Patina / Paths / Components
export readonly patina_path_components="$patina_path_root/components"
export readonly patina_path_components_applications="$patina_path_components/applications"
export readonly patina_path_components_places="$patina_path_components/places"
export readonly patina_path_components_system="$patina_path_components/system"
export readonly patina_path_components_user="$patina_path_components/user"

# Patina / Paths / System / Files
readonly system_os_release='/etc/os-release'
readonly system_lsb_release='/etc/lsb-release'

#############
# Functions #
#############

patina_initialize() {
  # Ensure Patina is operating inside of a GNU/Linux environment.
  if [ "$OSTYPE" != 'linux-gnu' ] ; then
    patina_throw_exception 'PE0018'
    return
  fi

  # Import additional system variables.
  if [ -f "$system_os_release" ] ; then source "$system_os_release" ; fi
  if [ -f "$system_lsb_release" ] ; then source "$system_lsb_release" ; fi

  # Create Patina Directory Structure.
  mkdir -p "$patina_path_configuration"
  mkdir -p "$patina_path_components"/{applications,places,system,user}

  # Success: Connect and apply Patina configuration.
  if [ -f "$patina_file_configuration" ] ; then
    chmod a-x "$patina_file_configuration"
    source "$patina_file_configuration"

  # Failure: Configuration file does not exist.
  else
    patina_create_configuration_file
  fi

  # Connect all detected Patina components.
  for component in "$patina_path_components"/{applications,places,system,user}/patina_*.sh ; do
    if [ -f "$component" ] ; then
      source "$component"
      patina_components_list+=("${component}")
    fi
  done

  # Lock variables after Patina is successfully loaded.
  readonly -a patina_components_list
  readonly TERM="$TERM"
  readonly OSTYPE="$OSTYPE"

  # Finally: Garbage collection.
  unset -f "${FUNCNAME[0]}"
}

patina_create_configuration_file() {
  # Default configuration options listed here.
  echo 'patina_theme=default' > "$patina_file_configuration"

  # Refresh the terminal to load new configuration.
  patina_terminal_refresh
}

patina_show_version_report() {
  # Failure: Success condition(s) not met.
  if [ "$#" -ge 1 ] ; then
    patina_throw_exception 'PE0002'
    return

  # Success: Display Patina information.
  elif [ "$#" -eq 0 ] ; then
    echo_wrap "Patina ${patina_metadata_version} '${patina_metadata_codename}'"
    echo_wrap "Copyright (C) 2020 William Whinn"
    echo_wrap "<${patina_metadata_url}>"
    echo_wrap "License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>."
    echo_wrap "This is free software: you are free to change and redistribute it."
    echo_wrap "There is NO WARRANTY, to the extent permitted by law."
    echo
    return

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

patina_show_component_report() {
  # Failure: Success condition(s) not met.
  if [ "$#" -ge 1 ] ; then
    patina_throw_exception 'PE0002'
    return

  # Success: Patina Component(s) detected.
  elif [[ -n "${patina_components_list[*]}" ]] ; then
    # Display Header
    echo
    echo_wrap "${bold}Patina Component Report${color_reset}\\n"
    echo_wrap "Patina has connected the following ${#patina_components_list[@]} component(s):\\n"

    # Success: 'tree' is installed. Display enhanced component list.
    if ( command -v 'tree' > /dev/null 2>&1 ) ; then
      tree --sort=name --dirsfirst --noreport --prune -P patina_*.sh "$patina_path_components"
      echo
      return

    # Success: 'tree' is not installed. Display standard component list.
    else
      for component in "${patina_components_list[@]}" ; do
        echo_wrap "$(basename "$component")"
      done

      echo
      return
    fi

  # Failure: Patina Component(s) were not detected.
  else
    patina_throw_exception 'PE0007'
    return
  fi
}

patina_show_dependency_report() {
  # Display Header.
  echo
  echo_wrap "${bold}Patina Dependency Report${color_reset}\\n"

  echo_wrap "${bold}NOTE${color_reset} Distribution-Native Packages Detected Only.\\n"

  # Display table header.
  echo_wrap "${bold}PACKAGE\\t\\tCOMMAND\\t\\tSTATE${color_reset}"

  printf "clamav\\t\\tp-clamscan"
  if ( command -v 'clamscan' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t${light_green}Installed${color_reset}"
  else
    echo_wrap "\\t${light_red}Not Installed${color_reset}"
  fi

  printf "genisoimage\tp-iso"
  if ( command -v 'mkisofs' > /dev/null 2>&1 ) ; then
    echo_wrap "\t\t${light_green}Installed${color_reset}"
  else
    echo_wrap "\t\t${light_red}Not Installed${color_reset}"
  fi

  printf "git\\t\\tp-update"
  if ( command -v 'git' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t${light_green}Installed${color_reset}"
  else
    echo_wrap "\\t${light_red}Not Installed${color_reset}"
  fi

  printf "gnupg2\\t\\tp-gpg"
  if ( command -v 'gpg' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t\\t${light_green}Installed${color_reset}"
  else
    echo_wrap "\\t\\t${light_red}Not Installed${color_reset}"
  fi

  printf "libreoffice\\tp-pdf"
  if ( command -v 'soffice' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t\\t${light_green}Installed${color_reset}"
  else
    echo_wrap "\\t\\t${light_red}Not Installed${color_reset}"
  fi

  printf "timeshift\\tp-timeshift"
  if ( command -v 'timeshift' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t${light_green}Installed${color_reset}"
  else
    echo_wrap "\\t${light_red}Not Installed${color_reset}"
  fi

  printf "tree\\t\\tp-list"
  if ( command -v 'tree' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t\\t${light_green}Installed${color_reset}"
  else
    echo_wrap "\\t\\t${light_red}Not Installed${color_reset}"
  fi

  printf "ufw\\t\\tp-ufw"
  if ( command -v 'ufw' > /dev/null 2>&1 ) ; then
    echo_wrap "\\t\\t${light_green}Installed${color_reset}"
  else
    echo_wrap "\\t\\t${light_red}Not Installed${color_reset}"
  fi

  echo
  return
}

patina_show_system_report() {
  # Failure: Patina has been given too many arguments.
  if [ "$#" -ge 1 ] ; then
    patina_throw_exception 'PE0002'
    return

  # Success: Display the Patina System Report.
  elif [ "$#" -eq 0 ] ; then
    # Display Header
    echo
    echo_wrap "${bold}Patina System Report${color_reset}\\n"

    # Show System Report
    echo_wrap "${bold}Operating System${color_reset}\\t$PRETTY_NAME"
    echo_wrap "${bold}Operating System URL${color_reset}\\t<$HOME_URL>"
    echo_wrap "${bold}Current Session${color_reset}\\t\\t$XDG_CURRENT_DESKTOP ($XDG_SESSION_TYPE)"
    echo_wrap "${bold}Linux Kernel Version${color_reset}\\t$(uname -r)"
    echo_wrap "${bold}Package Manager${color_reset}\\t\\t$(to_upper "${patina_package_manager}")"
    echo_wrap "${bold}BASH Version${color_reset}\\t\\t${BASH_VERSION%%[^0-9.]*}"

    echo
    return

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

patina_throw_exception() {
  # Failure: Patina has not been given an argument.
  if [ "$#" -eq 0 ] ; then
    patina_throw_exception 'PE0001'
    return

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
    return

  # Success: Display Patina Exception.
  elif [[ "$1" =~ [P][E][0-9][0-9][0-9][0-9] ]] ; then
    echo_wrap "${red}${!1}${color_reset}"
    return

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

patina_open_folder() {
  # Failure: Patina has not been given an argument.
  if [ "$#" -eq 0 ] ; then
    patina_throw_exception 'PE0001'
    return

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 2 ] ; then
    patina_throw_exception 'PE0002'
    return

  # Failure: Target is a file.
  elif [ -f "$1" ] ; then
    patina_throw_exception 'PE0003'
    return

  # Failure: Target directory does not exist
  elif [ ! -d "$1" ] ; then
    patina_throw_exception 'PE0004'
    return

  # Success: Change directory.
  elif [ -d "$1" ] && [ -z "$2" ] ; then
    cd "$1" || return
    return

  # Success: Change directory and open in graphical File Manager if possible.
  elif [ -d "$1" ] && [ "$2" ] ; then
    case "$2" in
      "-g")
        cd "$1" || return

        if ( command -v 'xdg-open' > /dev/null 2>&1 ) ; then
          xdg-open "$(pwd)" > /dev/null 2>&1
        fi

        return
        ;;
      *)
        patina_throw_exception 'PE0003'
        return
        ;;
    esac

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

generate_date_stamp() { date --utc +%Y%m%dT%H%M%SZ ; }

echo_wrap() {
  # Failure: Patina has not been given an argument.
  if [ "$#" -eq 0 ] ; then
    patina_throw_exception 'PE0001'
    return

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
    return

  # Success: Display wrapped text.
  elif [ -n "$1" ] ; then
    (echo -e "$1") | fmt -w "$(tput cols)"
    return

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

to_lower() {
  # Failure: Patina has not been given an argument.
  if [ "$#" -eq 0 ] ; then
    patina_throw_exception 'PE0001'
    return

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
    return

  # Success: Display text as lower-case.
  elif [ -n "$1" ] ; then
    echo -e "$1" | tr '[:upper:]' '[:lower:]'
    return

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

to_upper() {
  # Failure: Patina has not been given an argument.
  if [ "$#" -eq 0 ] ; then
    patina_throw_exception 'PE0001'
    return

  # Failure: Patina has been given too many arguments.
  elif [ "$#" -gt 1 ] ; then
    patina_throw_exception 'PE0002'
    return

  # Success: Display text as upper-case.
  elif [ -n "$1" ] ; then
    echo -e "$1" | tr '[:lower:]' '[:upper:]'
    return

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
    return
  fi
}

generate_uuid() {
  local label_command_6="head /dev/urandom | tr -dc A-Za-z0-9 | head -c6"
  local label_command_4="head /dev/urandom | tr -dc A-Za-z0-9 | head -c4"

  echo -e "$(eval "$label_command_6"; printf '-'; eval "$label_command_4"; \
    printf '-'; eval "$label_command_4"; printf '-'; eval "$label_command_4"; \
    printf '-'; eval "$label_command_4"; printf '-'; eval "$label_command_4"; \
    printf '-'; eval "$label_command_6"; )"
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
export -f 'generate_date_stamp'
export -f 'patina_throw_exception'
export -f 'to_lower'
export -f 'to_upper'
export -f 'generate_uuid'

###########
# Aliases #
###########

# Patina / Core
alias 'p-help'='less $patina_path_root/README.md'

# Patina / Reports
alias 'p-version'='patina_show_version_report'
alias 'p-deps'='patina_show_dependency_report'
alias 'p-list'='patina_show_component_report'
alias 'p-system'='patina_show_system_report'

alias 'p-refresh'='patina_terminal_refresh'
alias 'p-reset'='patina_terminal_reset'

# Patina / Places / Folders
alias 'files'='patina_open_folder "$HOME" -g'
alias 'p-root'='patina_open_folder $patina_path_root'

# Patina / Places / Components
alias 'p-c'='patina_open_folder $patina_path_components'
alias 'p-c-applications'='patina_open_folder $patina_path_components_applications'
alias 'p-c-places'='patina_open_folder $patina_path_components_places'
alias 'p-c-system'='patina_open_folder $patina_path_components_system'
alias 'p-c-user'='patina_open_folder $patina_path_components_user'

# Patina / Output
alias 'p-uuid'='generate_uuid'

#############
# Kickstart #
#############

patina_initialize

# End of File.
