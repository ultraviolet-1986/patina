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
# along with this program. If not, see <http://www.gnu.org/licenses/>.

#########################
# ShellCheck Directives #
#########################

# Override SC2154: "var is referenced but not assigned".
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_detect_system_package_manager() {
  # Success: Distribution is Ubuntu or compatible.
  if ( hash 'apt' > /dev/null 2>&1 ) ; then
    readonly patina_package_manager='apt'
    readonly patina_package_install='install'
    readonly patina_package_remove='remove'
    readonly patina_package_update='update'
    readonly patina_package_upgrade='upgrade'

  # Success: Distribution is Fedora or compatible.
  elif ( hash 'dnf' > /dev/null 2>&1 ) ; then
    readonly patina_package_manager='dnf'
    readonly patina_package_install='install'
    readonly patina_package_remove='remove'
    readonly patina_package_update='check-update'
    readonly patina_package_upgrade='upgrade'

  # Success: Distribution is Solus or compatible.
  elif ( hash 'eopkg' > /dev/null 2>&1 ) ; then
    readonly patina_package_manager='eopkg'
    readonly patina_package_install='install'
    readonly patina_package_remove='remove'
    readonly patina_package_update='update-repo'
    readonly patina_package_upgrade='upgrade'

  # Success: Distribution is Arch or compatible.
  elif ( hash 'pacman' > /dev/null 2>&1 ) ; then
    readonly patina_package_manager='pacman'
    readonly patina_package_install='-S'
    readonly patina_package_remove='-R'
    readonly patina_package_update='-Syu'
    readonly patina_package_upgrade='-Syu'

  # Success: Distribution is Fedora Silverblue or compatible.
  elif ( hash 'rpm-ostree' > /dev/null 2>&1 ) ; then
    readonly patina_package_manager='rpm-ostree'
    readonly patina_package_install='install'
    readonly patina_package_remove='uninstall'
    readonly patina_package_update='refresh-md'
    readonly patina_package_upgrade='upgrade'

  # Success: Distribution is openSUSE or compatible.
  elif ( hash 'zypper' > /dev/null 2>&1 ) ; then
    readonly patina_package_manager='zypper'
    readonly patina_package_install='install'
    readonly patina_package_remove='remove'
    readonly patina_package_update='refresh'
    readonly patina_package_upgrade='update'

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi

  # Rubbish collection
  unset -f "${FUNCNAME[0]}"
}

# Warning: sudo command(s)
patina_package_manager() {
  # Check Internet connection before starting
  patina_detect_internet_connection

  if [ "$patina_has_internet" = 'false' ] ; then
    patina_throw_exception 'PE0008'
    return

  elif [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
    return

  else
    case "$1" in
      'install')
        if [ -z "$2" ] ; then
          patina_throw_exception 'PE0001'
          return
        else
          if [ "$patina_package_manager" = 'rpm-ostree' ] ; then
            eval "$patina_package_manager" "$patina_package_install" "${@:2}"
          else
            sudo "$patina_package_manager" "$patina_package_install" "${@:2}"
          fi
          return
        fi
        ;;
      'remove')
        if [ -z "$2" ] ; then
          patina_throw_exception 'PE0001'
        else
          if [ "$patina_package_manager" = 'rpm-ostree' ] ; then
            eval "$patina_package_manager" "$patina_package_remove" "${@:2}"
          else
            sudo "$patina_package_manager" "$patina_package_remove" "${@:2}"
          fi
          return
        fi
        ;;
      'update')
        if [ "$patina_package_manager" = 'dnf' ] ; then
          eval "$patina_package_manager" "$patina_package_update" --refresh
        elif [ "$patina_package_manager" = 'rpm-ostree' ] ; then
          eval "$patina_package_manager" "$patina_package_upgrade" --check
        else
          sudo "$patina_package_manager" "$patina_package_update"
        fi
        return
        ;;
      'upgrade')
        if [ "$patina_package_manager" = 'rpm-ostree' ] ; then
          eval "$patina_package_manager" "$patina_package_upgrade"
        else
          sudo "$patina_package_manager" "$patina_package_upgrade" --refresh
        fi
        return
        ;;
      *) patina_throw_exception 'PE0003' ;;
    esac
  fi
}

###########
# Aliases #
###########

alias 'p-package'='patina_package_manager'
alias 'p-pkg'='patina_package_manager'

#############
# Kickstart #
#############

patina_detect_system_package_manager

# End of File.
