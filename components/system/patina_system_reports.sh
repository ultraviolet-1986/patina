#!/usr/bin/env bash

###########
# License #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2021 William Willis Whinn

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
# Functions #
#############

# PATINA > FUNCTIONS > REPORTS

patina_show_component_report() {
  # Failure: Success condition(s) not met.
  if [ "$#" -ge 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  # Success: Patina Component(s) detected.
  elif [[ -n "${patina_components_list[*]}" ]] ; then
    # Display Header
    echo
    echo -e "${BOLD}Patina Component Report${COLOR_RESET}\\n"
    echo -e "Patina has connected the following ${#patina_components_list[@]} component(s):\\n"

    # Success: 'tree' is installed. Display enhanced component list.
    if ( command -v 'tree' > /dev/null 2>&1 ) ; then
      tree --sort=name --dirsfirst --noreport --prune -P patina_*.sh "$PATINA_PATH_COMPONENTS"
      echo
      return 0

    # Success: 'tree' is not installed. Display standard component list.
    else
      for component in "${patina_components_list[@]}" ; do
        echo -e "$( basename "$component" )"
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
  echo -e "${BOLD}Patina Dependency Report${COLOR_RESET}\\n"

  echo -e "${BOLD}NOTE${COLOR_RESET} Distribution-Native Packages Detected Only.\\n"

  # Display table header.
  echo -e "${BOLD}PACKAGE\\t\\tCOMMAND\\t\\t\\tSTATE${COLOR_RESET}"

  printf "clamav\\t\\tp-clamscan"
  if ( command -v 'clamscan' > /dev/null 2>&1 ) ; then
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}"
  else
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"
  fi

  printf "genisoimage\\tp-iso"
  if ( command -v 'mkisofs' > /dev/null 2>&1 ) ; then
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}"
  else
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"
  fi

  printf "git\\t\\tp-update"
  if ( command -v 'git' > /dev/null 2>&1 ) ; then
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}"
  else
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"
  fi

  # Additional uses for 'git'.
  printf "^\\t\\tp-gitupdate\\t\\t^\\n"

  printf "gnupg2\\t\\tp-gpg"
  if ( command -v 'gpg' > /dev/null 2>&1 ) ; then
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}"
  else
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"
  fi

  printf "libreoffice\\tp-pdf"
  if ( command -v 'soffice' > /dev/null 2>&1 ) ; then
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}"
  else
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"
  fi

  printf "sed\\t\\tp-b2sum"
  if ( command -v 'sed' > /dev/null 2>&1 ) ; then
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}"
  else
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"
  fi

  # Additional uses for 'sed'.
  printf "^\\t\\tp-md5sum\\t\\t^\\n"
  printf "^\\t\\tp-sha1sum\\t\\t^\\n"
  printf "^\\t\\tp-sha224sum\\t\\t^\\n"
  printf "^\\t\\tp-sha256sum\\t\\t^\\n"
  printf "^\\t\\tp-sha384sum\\t\\t^\\n"
  printf "^\\t\\tp-sha512sum\\t\\t^\\n"

  printf "squashfs-tools\\tp-squash"
  if ( command -v 'mksquashfs' > /dev/null 2>&1 ) ; then
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}"
  else
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"
  fi

  printf "toolbox\\t\\tp-toolbox"
  if ( command -v 'toolbox' > /dev/null 2>&1 ) ; then
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}"
  else
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"
  fi

  printf "podman\\t\\t^"
  if ( command -v 'podman' > /dev/null 2>&1 ) ; then
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}"
  else
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"
  fi

  printf "timeshift\\tp-timeshift"
  if ( command -v 'timeshift' > /dev/null 2>&1 ) ; then
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}"
  else
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"
  fi

  printf "tree\\t\\tp-list"
  if ( command -v 'tree' > /dev/null 2>&1 ) ; then
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}"
  else
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"
  fi

  printf "ufw\\t\\tp-ufw"
  if ( command -v 'ufw' > /dev/null 2>&1 ) ; then
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}"
  else
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"
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
    patina_detect_internet_connection

    local network_status

    if ( patina_detect_internet_connection ) ; then
      network_status="${GREEN}Active${COLOR_RESET}"
    else
      network_status="${RED}Inactive${COLOR_RESET}"
    fi

    # Display Header
    echo
    echo -e "${BOLD}Patina System Report${COLOR_RESET}\\n"

    # Show System Report
    echo -e "${BOLD}Operating System${COLOR_RESET}\\t${PRETTY_NAME}"
    echo -e "${BOLD}Operating System URL${COLOR_RESET}\\t<${HOME_URL}>"
    echo -e "${BOLD}Machine Architecture${COLOR_RESET}\\t$( uname -m )"
    echo -e "${BOLD}Desktop Session${COLOR_RESET}\\t\\t${XDG_CURRENT_DESKTOP}"
    echo -e "${BOLD}Display Server${COLOR_RESET}\\t\\t$( to_upper "${XDG_SESSION_TYPE}" )"
    echo -e "${BOLD}Linux Kernel Version${COLOR_RESET}\\t$( uname -r )"
    echo -e "${BOLD}Package Manager${COLOR_RESET}\\t\\t$( to_upper "${PATINA_PACKAGE_MANAGER}" )"
    echo -e "${BOLD}BASH Version${COLOR_RESET}\\t\\t${BASH_VERSION%%[^0-9.]*}"
    echo -e "${BOLD}Internet Connection${COLOR_RESET}\\t${network_status}"

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

# PATINA > FUNCTIONS > SYSTEM REPORT COMMANDS

alias 'p-deps'='patina_show_dependency_report'
alias 'p-list'='patina_show_component_report'
alias 'p-system'='patina_show_system_report'

# End of File.
