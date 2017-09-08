#!/bin/bash

##############
# Directives #
##############

# ShellCheck does not have permissions to follow some paths
# shellcheck disable=SC1091

# '$lsb_release_file' value is not a fixed location
# shellcheck disable=SC1090

# Some variables are defined elsewhere
# shellcheck disable=SC2154

#############
# Variables #
#############

readonly lsb_release_file='/etc/lsb-release'

#############
# Functions #
#############

patina_source_lsb_release() {
  # Success: 'lsb_release path' exists
  if [ -e "$lsb_release_file" ] ; then
    source "$lsb_release_file"
  fi
}

patina_identify_operating_system() {
  # Success: '$DISTRIB_DESCRIPTION' is a valid variable
  if [ "$DISTRIB_DESCRIPTION" ] ; then
    echo_wrap "\\n${patina_major_color}Patina${color_reset} is running on: ${patina_minor_color}$DISTRIB_DESCRIPTION${color_reset}.\\n"
  else
    echo_wrap "\\n${patina_major_color}Patina${color_reset} cannot detect your operating system.\\n"
  fi
}

###########
# Aliases #
###########

alias 'p-os'='patina_identify_operating_system'

#############
# Kickstart #
#############

patina_source_lsb_release

# End of File.
