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
    echo_wrap "\\n${patina_major_color}Patina${color_reset} has already detected the default package manager.\\n"

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
    echo_wrap "\\nIt appears that ${patina_major_color}Patina${color_reset} does not currently support package management on your Linux distribution. For more information or to make a request, please visit: ${patina_major_color}$patina_metadata_url${color_reset}\\n"
  fi
}

# Warning: sudo command(s)
patina_package_manager() {
  if [ "$#" -eq "0" ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} has not been given an argument. Please use ${patina_minor_color}install${color_reset}, ${patina_minor_color}remove${color_reset}, ${patina_minor_color}update${color_reset}, or ${patina_minor_color}upgrade${color_reset}.\\n"

  else
    case "$1" in
      'install')
        if [ ! "$2" ] ; then
          echo_wrap "\\n${patina_major_color}Patina${color_reset} has not been given package name(s) to install.\\n"
        else
          sudo "$patina_package_manager" "$patina_package_install" "${@:2}"
        fi
        ;;
      'remove')
        if [ ! "$2" ] ; then
          echo_wrap "\\n${patina_major_color}Patina${color_reset} has not been given package name(s) to remove.\\n"
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
        echo_wrap "\\n${patina_major_color}Patina${color_reset} has not been given a supported argument. Please use ${patina_minor_color}install${color_reset}, ${patina_minor_color}remove${color_reset}, ${patina_minor_color}update${color_reset}, or ${patina_minor_color}upgrade${color_reset}.\\n"
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
