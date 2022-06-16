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
# Functions #
#############

patina_report_components() {
  if [ "$#" -ge 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  elif [[ -n "${patina_components_list[*]}" ]] ; then
    echo -e "\\n${BOLD}Patina Component Report${COLOR_RESET}\\n"
    echo -e "Patina has connected the following ${#patina_components_list[@]} component(s):\\n"

    if ( command -v 'tree' > /dev/null 2>&1 ) ; then
      tree --sort=name --dirsfirst --noreport --prune -P patina_*.sh "${PATINA_PATH_COMPONENTS}"
      echo
      return 0
    else
      for component in "${patina_components_list[@]}" ; do
        echo -e "$( basename "${component}" )"
      done

      echo
      return 0
    fi
  else
    patina_raise_exception 'PE0007'
    return 1
  fi
}

patina_report_dependencies() {
  echo -e "\\n${BOLD}Patina Dependency Report${COLOR_RESET}\\n"
  echo -e "${BOLD}NOTE${COLOR_RESET} Distribution-Native Packages Detected Only.\\n"

  echo -e "${BOLD}PACKAGE\\t\\tCOMMAND\\t\\t\\tSTATE${COLOR_RESET}"

  printf "clamav\\t\\tp-clamscan"
  ( command -v 'clamscan' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"

  printf "fdkaac\\t\\tp-wav2aac"
  ( command -v 'fdkaac' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"

  printf "flac\\t\\tp-wav2flac"
  ( command -v 'flac' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"
  printf "^\\t\\tp-flac2wav\\t\\t^\\n"

  printf "genisoimage\\tp-iso"
  ( command -v 'mkisofs' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"

  printf "git\\t\\tp-update"
  ( command -v 'git' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"
  printf "^\\t\\tp-gitupdate\\t\\t^\\n"

  printf "gpg\\t\\tp-gpg"
  ( command -v 'gpg' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"

  printf "lame\\t\\tp-wav2mp3"
  ( command -v 'lame' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"

  printf "libreoffice\\tp-pdf"
  ( command -v 'soffice' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"

  printf "sed\\t\\tp-b2sum"
  ( command -v 'sed' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"
  printf "^\\t\\tp-md5sum\\t\\t^\\n"
  printf "^\\t\\tp-sha1sum\\t\\t^\\n"
  printf "^\\t\\tp-sha224sum\\t\\t^\\n"
  printf "^\\t\\tp-sha256sum\\t\\t^\\n"
  printf "^\\t\\tp-sha384sum\\t\\t^\\n"
  printf "^\\t\\tp-sha512sum\\t\\t^\\n"

  printf "squashfs-tools\\tp-squash"
  ( command -v 'mksquashfs' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"

  printf "toolbox\\t\\tp-toolbox"
  ( command -v 'toolbox' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"

  printf "podman\\t\\t^"
  ( command -v 'podman' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"

  printf "timeshift\\tp-timeshift"
  ( command -v 'timeshift' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"

  printf "tree\\t\\tp-list"
  ( command -v 'tree' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"

  printf "ufw\\t\\tp-ufw"
  ( command -v 'ufw' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t\\t${RED}Not Installed${COLOR_RESET}"

  printf "vorbis-tools\\tp-wav2vorbis"
  ( command -v 'oggenc' > /dev/null 2>&1 ) && \
    echo -e "\\t\\t${GREEN}Installed${COLOR_RESET}" || \
    echo -e "\\t\\t${RED}Not Installed${COLOR_RESET}"

  echo
  return 0
}

patina_report_system() {
  if [ "$#" -ge 1 ] ; then
    patina_raise_exception 'PE0002'
    return 1

  elif [ "$#" -eq 0 ] ; then
    local network_status

    patina_detect_internet_connection && \
      network_status="${GREEN}Active${COLOR_RESET}" || \
      network_status="${RED}Inactive${COLOR_RESET}"

    echo -e "\\n${BOLD}Patina System Report${COLOR_RESET}\\n"

    echo -e "${BOLD}Operating System${COLOR_RESET}\\t${PRETTY_NAME}"
    echo -e "${BOLD}Operating System URL${COLOR_RESET}\\t${HOME_URL}"
    echo -e "${BOLD}Machine Architecture${COLOR_RESET}\\t$( uname -m )"
    echo -e "${BOLD}Desktop Session${COLOR_RESET}\\t\\t${XDG_CURRENT_DESKTOP}"
    echo -e "${BOLD}Display Server${COLOR_RESET}\\t\\t$( to_upper "${XDG_SESSION_TYPE}" )"
    echo -e "${BOLD}Linux Kernel Version${COLOR_RESET}\\t$( uname -r )"
    echo -e "${BOLD}Package Manager${COLOR_RESET}\\t\\t$( to_upper "${PATINA_PACKAGE_MANAGER}" )"
    echo -e "${BOLD}BASH Version${COLOR_RESET}\\t\\t${BASH_VERSION%%[^0-9.]*}"
    echo -e "${BOLD}Internet Connection${COLOR_RESET}\\t${network_status}\\n"

    return 0
  else
    patina_raise_exception 'PE0000'
    return 1
  fi
}

###########
# Aliases #
###########

alias 'p-list'='patina_report_components'
alias 'p-deps'='patina_report_dependencies'
alias 'p-system'='patina_report_system'

# End of File.
