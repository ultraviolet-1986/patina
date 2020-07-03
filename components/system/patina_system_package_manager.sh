#!/usr/bin/env bash

###########
# LICENSE #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License along with this program. If not,
# see <http://www.gnu.org/licenses/>.

#########################
# SHELLCHECK DIRECTIVES #
#########################

# Override SC2154: "var is referenced but not assigned".
# shellcheck disable=SC2154

#############
# FUNCTIONS #
#############

patina_detect_system_package_manager() {
  # Success: Distribution is Ubuntu or compatible.
  if ( command -v 'apt' > /dev/null 2>&1 ) ; then
    readonly PATINA_PACKAGE_MANAGER='apt'
    readonly PATINA_PACKAGE_INSTALL='install'
    readonly PATINA_PACKAGE_REMOVE='remove'
    readonly PATINA_PACKAGE_UPDATE='update'
    readonly PATINA_PACKAGE_UPGRADE='upgrade'

  # Success: Distribution is Fedora or compatible.
  elif ( command -v 'dnf' > /dev/null 2>&1 ) ; then
    readonly PATINA_PACKAGE_MANAGER='dnf'
    readonly PATINA_PACKAGE_INSTALL='install'
    readonly PATINA_PACKAGE_REMOVE='remove'
    readonly PATINA_PACKAGE_UPDATE='check-update'
    readonly PATINA_PACKAGE_UPGRADE='upgrade'

  # Success: Distribution is Solus or compatible.
  elif ( command -v 'eopkg' > /dev/null 2>&1 ) ; then
    readonly PATINA_PACKAGE_MANAGER='eopkg'
    readonly PATINA_PACKAGE_INSTALL='install'
    readonly PATINA_PACKAGE_REMOVE='remove'
    readonly PATINA_PACKAGE_UPDATE='update-repo'
    readonly PATINA_PACKAGE_UPGRADE='upgrade'

  # Success: Distribution is Arch or compatible.
  elif ( command -v 'pacman' > /dev/null 2>&1 ) ; then
    readonly PATINA_PACKAGE_MANAGER='pacman'
    readonly PATINA_PACKAGE_INSTALL='-S'
    readonly PATINA_PACKAGE_REMOVE='-R'
    readonly PATINA_PACKAGE_UPDATE='-Syu'
    readonly PATINA_PACKAGE_UPGRADE='-Syu'

  # Success: Distribution is Fedora Silverblue or compatible.
  elif ( command -v 'rpm-ostree' > /dev/null 2>&1 ) ; then
    readonly PATINA_PACKAGE_MANAGER='rpm-ostree'
    readonly PATINA_PACKAGE_INSTALL='install'
    readonly PATINA_PACKAGE_REMOVE='uninstall'
    readonly PATINA_PACKAGE_UPDATE='refresh-md'
    readonly PATINA_PACKAGE_UPGRADE='upgrade'

  # Success: Distribution is openSUSE or compatible.
  elif ( command -v 'zypper' > /dev/null 2>&1 ) ; then
    readonly PATINA_PACKAGE_MANAGER='zypper'
    readonly PATINA_PACKAGE_INSTALL='install'
    readonly PATINA_PACKAGE_REMOVE='remove'
    readonly PATINA_PACKAGE_UPDATE='refresh'
    readonly PATINA_PACKAGE_UPGRADE='update'

  # Failure: Catch all.
  else
    patina_raise_exception 'PE0000'
  fi

  # Finally: Garbage collection.
  unset -f "${FUNCNAME[0]}"
}

# Warning: Uses sudo command(s) to perform software management tasks.
patina_package_manager() {
  if [ "$1" = '--help' ] ; then
    echo -e "Usage: p-pkg [OPTION] [PACKAGE(S)]"
    echo -e "Warning: Command(s) may require 'sudo' password."
    echo -e "Connect to system package manager to perform software management tasks."
    echo
    echo -e "  install\\tInstall package(s)."
    echo -e "  remove\\tRemove package(s)."
    echo -e "  update\\tUpdate package repository information."
    echo -e "  upgrade\\tUpgrade system software."
    echo -e "  --help\tDisplay this help and exit."
    echo
    return 0
  fi

  patina_detect_internet_connection

  if [ "$PATINA_HAS_INTERNET" = 'false' ] ; then
    patina_raise_exception 'PE0008'
    return 1

  elif [ "$#" -eq 0 ] ; then
    patina_raise_exception 'PE0001'
    return 1

  else
    case "$1" in
      'install')
        if [ -z "$2" ] ; then
          patina_raise_exception 'PE0001'
          return 1
        else
          if [ "$PATINA_PACKAGE_MANAGER" = 'rpm-ostree' ] ; then
            eval "$PATINA_PACKAGE_MANAGER" "$PATINA_PACKAGE_INSTALL" "${@:2}"
            return 0
          else
            sudo "$PATINA_PACKAGE_MANAGER" "$PATINA_PACKAGE_INSTALL" "${@:2}"
            return 0
          fi
        fi
        ;;
      'remove')
        if [ -z "$2" ] ; then
          patina_raise_exception 'PE0001'
          return 1
        else
          if [ "$PATINA_PACKAGE_MANAGER" = 'rpm-ostree' ] ; then
            eval "$PATINA_PACKAGE_MANAGER" "$PATINA_PACKAGE_REMOVE" "${@:2}"
            return 0
          else
            sudo "$PATINA_PACKAGE_MANAGER" "$PATINA_PACKAGE_REMOVE" "${@:2}"
            return 0
          fi
        fi
        ;;
      'update')
        if [ "$PATINA_PACKAGE_MANAGER" = 'dnf' ] ; then
          eval "$PATINA_PACKAGE_MANAGER" "$PATINA_PACKAGE_UPDATE" --refresh
          return 0
        elif [ "$PATINA_PACKAGE_MANAGER" = 'rpm-ostree' ] ; then
          eval "$PATINA_PACKAGE_MANAGER" "$PATINA_PACKAGE_UPDATE"
          return 0
        else
          sudo "$PATINA_PACKAGE_MANAGER" "$PATINA_PACKAGE_UPDATE"
          return 0
        fi
        ;;
      'upgrade')
        if [ "$PATINA_PACKAGE_MANAGER" = 'dnf' ] ; then
          sudo "$PATINA_PACKAGE_MANAGER" "$PATINA_PACKAGE_UPGRADE" --refresh
          return 0
        elif [ "$PATINA_PACKAGE_MANAGER" = 'rpm-ostree' ] ; then
          eval "$PATINA_PACKAGE_MANAGER" "$PATINA_PACKAGE_UPGRADE"
          return 0
        else
          sudo "$PATINA_PACKAGE_MANAGER" "$PATINA_PACKAGE_UPGRADE"
          return 0
        fi
        ;;
      *)
        patina_raise_exception 'PE0003'
        return 1
        ;;
    esac
  fi
}

###########
# ALIASES #
###########

# PATINA > FUNCTIONS > PACKAGE MANAGEMENT COMMANDS

alias 'p-pkg'='patina_package_manager'

#############
# KICKSTART #
#############

patina_detect_system_package_manager

# End of File.
