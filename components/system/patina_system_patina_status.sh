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

# TODO Check for errors.

#############
# Variables #
#############

#############
# Functions #
#############

patina_check_patina_status(){
  echo_wrap "\nPatina-Compatible Applications:"

  echo_wrap "\nNOTE: Distribution-Native Packages Detected Only.\n"

  printf "ClamAV (p-clamscan): "
  if ( command -v 'clamscan' > /dev/null 2>&1 ) ; then
    echo_wrap "${light_green}Installed${color_reset}"
  else
    echo_wrap "${light_red}Not Installed${color_reset}"
  fi

  printf "genisoimage (p-iso): "
  if ( command -v 'mkisofs' > /dev/null 2>&1 ) ; then
    echo_wrap "${light_green}Installed${color_reset}"
  else
    echo_wrap "${light_red}Not Installed${color_reset}"
  fi

  printf "Git (p-update): "
  if ( command -v 'git' > /dev/null 2>&1 ) ; then
    echo_wrap "${light_green}Installed${color_reset}"
  else
    echo_wrap "${light_red}Not Installed${color_reset}"
  fi

  printf "LibreOffice (p-pdf): "
  if ( command -v 'soffice' > /dev/null 2>&1 ) ; then
    echo_wrap "${light_green}Installed${color_reset}"
  else
    echo_wrap "${light_red}Not Installed${color_reset}"
  fi

  printf "Timeshift (p-timeshift): "
  if ( command -v 'timeshift' > /dev/null 2>&1 ) ; then
    echo_wrap "${light_green}Installed${color_reset}"
  else
    echo_wrap "${light_red}Not Installed${color_reset}"
  fi

  printf "tree (p-list): "
  if ( command -v 'tree' > /dev/null 2>&1 ) ; then
    echo_wrap "${light_green}Installed${color_reset}"
  else
    echo_wrap "${light_red}Not Installed${color_reset}"
  fi

  printf "UFW / Uncomplicated Firewall (p-ufw): "
  if ( command -v 'ufw' > /dev/null 2>&1 ) ; then
    echo_wrap "${light_green}Installed${color_reset}"
  else
    echo_wrap "${light_red}Not Installed${color_reset}"
  fi

  echo
  return
}

###########
# Aliases #
###########

alias 'p-status'='patina_check_patina_status'

# End of File.
