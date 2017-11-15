#!/bin/bash

##############
# Directives #
##############

# Some variables are defined elsewhere
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_detect_system_package_manager() {
  # Failure: Default package manager already defined
  if [ "$patina_package_manager" ] ; then
    echo_wrap "Patina has already detected the default package manager."

  # Success: Distribution is Ubuntu or compatible
  elif ( hash 'apt' > /dev/null 2>&1 ) ; then
    readonly patina_package_manager='apt'
    readonly patina_package_install='install'
    readonly patina_package_remove='remove'
    readonly patina_package_update='update'
    readonly patina_package_upgrade='upgrade'

  # Success: Distribution is Fedora or compatible
  elif ( hash 'dnf' > /dev/null 2>&1 ) ; then
    readonly patina_package_manager='dnf'
    readonly patina_package_install='install'
    readonly patina_package_remove='remove'
    readonly patina_package_update='check-update'
    readonly patina_package_upgrade='update'

  # Success: Distribution is Solus or compatible
  elif ( hash 'eopkg' > /dev/null 2>&1 ) ; then
    readonly patina_package_manager='eopkg'
    readonly patina_package_install='install'
    readonly patina_package_remove='remove'
    readonly patina_package_update='update-repo'
    readonly patina_package_upgrade='upgrade'

  # Success: Distribution is Arch or compatible
  elif ( hash 'pacman' > /dev/null 2>&1 ) ; then
    readonly patina_package_manager='pacman'
    readonly patina_package_install='-S'
    readonly patina_package_remove='-R'
    readonly patina_package_update='-Syu'
    readonly patina_package_upgrade='-Syu'

  # Success: Distribution is openSUSE or compatible
  elif ( hash 'zypper' > /dev/null 2>&1 ) ; then
    readonly patina_package_manager='zypper'
    readonly patina_package_install='install'
    readonly patina_package_remove='remove'
    readonly patina_package_update='refresh'
    readonly patina_package_upgrade='update'

  # Failure: Catch any other error condition here
  else
    echo_wrap "It appears that Patina does not currently support package management on your Linux distribution. For more information or to make a request, please visit: $patina_metadata_url."
  fi
}

# Warning: sudo command(s)
patina_package_manager() {
  if [ "$#" -eq "0" ] ; then
    echo_wrap "Patina has not been given an argument. Please use 'install', 'remove', 'update', or 'upgrade'."

  else
    case "$1" in
      'install')
        if [ ! "$2" ] ; then
          echo_wrap "Patina has not been given package name(s) to install."
        else
          sudo "$patina_package_manager" "$patina_package_install" "${@:2}"
        fi
        ;;
      'remove')
        if [ ! "$2" ] ; then
          echo_wrap "Patina has not been given package name(s) to remove."
        else
          sudo "$patina_package_manager" "$patina_package_remove" "${@:2}"
        fi
        ;;
      'update')
        sudo "$patina_package_manager" "$patina_package_update"
        ;;
      'upgrade')
        sudo "$patina_package_manager" "$patina_package_upgrade"
        ;;
      *)
        echo_wrap "Patina has not been given a supported argument. Please use 'install', 'remove', 'update', or 'upgrade'."
        ;;
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
