#!/usr/bin/env bash

##############
# Directives #
##############

# Some items are defined elsewhere
# shellcheck disable=SC2154

#############
# Variables #
#############

# Text / Colors
readonly blue='\e[34m'
readonly cyan='\e[36m'
readonly green='\e[32m'
readonly magenta='\e[35m'
readonly red='\e[31m'
readonly yellow='\e[33m'

readonly light_blue='\e[94m'
readonly light_cyan='\e[96m'
readonly light_gray='\e[37m'
readonly light_green='\e[92m'
readonly light_magenta='\e[95m'
readonly light_red='\e[91m'
readonly light_yellow='\e[93m'

readonly black='\e[30m'
readonly gray='\e[90m'
readonly white='\e[97m'

# Text / Formatting
readonly bold='\e[1m'
readonly underline='\e[4m'

readonly color_default='\e[39m'
readonly color_reset='\e[0m'

#############
# Functions #
#############

patina_theme_apply() {
  # Failure: Patina has not been given an argument
  if [ "$#" -eq "0" ] ; then
    patina_throw_exception 'PE0001'
    return

  # Failure: Patina has been given multiple arguments
  elif [ "$#" -gt "1" ] ; then
    patina_throw_exception 'PE0002'
    return

  # Default theme
  elif [ "$1" = 'default' ] ; then
    patina_theme_apply 'magenta'

  # Standard themes
  elif [ "$1" = 'blue' ] ; then
    export patina_major_color="${light_blue}"
    export patina_minor_color="${blue}"

  elif [ "$1" = 'cyan' ] ; then
    export patina_major_color="${light_cyan}"
    export patina_minor_color="${cyan}"

  elif [ "$1" = 'green' ] ; then
    export patina_major_color="${light_green}"
    export patina_minor_color="${green}"

  elif [ "$1" = 'magenta' ] ; then
    export patina_major_color="${light_magenta}"
    export patina_minor_color="${magenta}"

  elif [ "$1" = 'red' ] ; then
    export patina_major_color="${light_red}"
    export patina_minor_color="${red}"

  elif [ "$1" = 'yellow' ] ; then
    export patina_major_color="${light_yellow}"
    export patina_minor_color="${yellow}"

  # Monochrome themes
  elif [ "$1" = 'black' ] ; then
    export patina_major_color="${black}"
    export patina_minor_color="${black}"

  elif [ "$1" = 'gray' ] || [ "$1" = 'grey' ] ; then
    export patina_major_color="${light_gray}"
    export patina_minor_color="${gray}"

  elif [ "$1" = 'white' ] ; then
    export patina_major_color="${white}"
    export patina_minor_color="${white}"

  # Additional themes
  elif [ "$1" = 'blossom' ] ; then
    export patina_major_color="${light_magenta}"
    export patina_minor_color="${light_red}"

  elif [ "$1" = 'classic' ] ; then
    export patina_major_color="${light_magenta}"
    export patina_minor_color="${light_cyan}"

  elif [ "$1" = 'cygwin' ] ; then
    export patina_major_color="${light_green}"
    export patina_minor_color="${light_yellow}"

  elif [ "$1" = 'gravity' ] ; then
    export patina_major_color="${light_magenta}"
    export patina_minor_color="${light_yellow}"

  elif [ "$1" = 'mint' ] ; then
    export patina_major_color="${light_green}"
    export patina_minor_color="${light_blue}"

  elif [ "$1" = 'varia' ] ; then
    export patina_major_color="${light_red}"
    export patina_minor_color="${light_yellow}"

  elif [ "$1" = 'water' ] ; then
    export patina_major_color="${light_blue}"
    export patina_minor_color="${cyan}"

  # Failure: Catch any other error condition here
  else
    patina_theme_apply 'default'
    return
  fi

  # Export the selected theme
  export patina_theme="$1"

  # Update configuration file
  sed -i "s/patina_theme=.*$/patina_theme=${patina_theme}/g" "$patina_file_configuration"

  # Refresh the prompt
  export PS1="\\[\\e]2;Patina \\w\\a\\]\\[${patina_major_color}\\]\\u@\\h\\[${color_reset}\\] \\[${patina_minor_color}\\]\\w\\[${color_reset}\\] P\\$ "
}

###########
# Aliases #
###########

# Colors
alias 'p-theme'='patina_theme_apply'

# End of File.
