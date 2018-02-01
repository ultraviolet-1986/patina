#!/bin/bash

##############
# Directives #
##############

# Some variables are defined elsewhere
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_theme_apply() {
  # Failure: Patina is running in a low-color mode
  if [ "$TERM" = 'linux' ] ; then
    clear
    echo_wrap "Patina has temporarily disabled theming for this low-color session.\\n"
    set -- "${color_default}" "${color_default}"

  # Failure: Patina has not been given an argument
  elif [ "$#" -eq "0" ] ; then
    echo_wrap "Patina has not been given the name of a theme, please try again."

  # Failure: Patina has been given multiple arguments
  elif [ "$#" -gt "1" ] ; then
    echo_wrap "Patina must be given the name of only one theme, please try again."

  # Success: Patina has been given a single argument
  elif [ "$1" ] ; then
    case "$1" in
      # Define default theme
      'default')
        patina_theme_apply 'magenta'
        ;;

      # Standard themes
      'blue')
        export patina_major_color="${light_blue}"
        export patina_minor_color="${blue}"
        ;;
      'cyan')
        export patina_major_color="${light_cyan}"
        export patina_minor_color="${cyan}"
        ;;
      'green')
        export patina_major_color="${light_green}"
        export patina_minor_color="${green}"
        ;;
      'magenta')
        export patina_major_color="${light_magenta}"
        export patina_minor_color="${magenta}"
        ;;
      'red')
        export patina_major_color="${light_red}"
        export patina_minor_color="${red}"
        ;;
      'yellow')
        export patina_major_color="${light_yellow}"
        export patina_minor_color="${yellow}"
        ;;

      # Monochrome themes
      'black')
        export patina_major_color="${black}"
        export patina_minor_color="${black}"
        ;;
      'gray' | 'grey')
        export patina_major_color="${light_gray}"
        export patina_minor_color="${gray}"
        ;;
      'white')
        export patina_major_color="${white}"
        export patina_minor_color="${white}"
        ;;

      # Additional themes
      'blossom')
        export patina_major_color="${light_magenta}"
        export patina_minor_color="${light_red}"
        ;;
      'classic')
        export patina_major_color="${light_magenta}"
        export patina_minor_color="${light_cyan}"
        ;;
      'cygwin')
        export patina_major_color="${light_green}"
        export patina_minor_color="${light_yellow}"
        ;;
      'gravity')
        export patina_major_color="${light_magenta}"
        export patina_minor_color="${light_yellow}"
        ;;
      'mint')
        export patina_major_color="${light_green}"
        export patina_minor_color="${light_blue}"
        ;;
      'varia')
        export patina_major_color="${light_red}"
        export patina_minor_color="${light_yellow}"
        ;;
      'water')
        export patina_major_color="${light_blue}"
        export patina_minor_color="${cyan}"
        ;;
      *)
        echo_wrap "'$1' is not a known theme, default has been applied."
        patina_theme_apply 'default'
        ;;
    esac

    # Export the selected theme
    export patina_theme="$1"

    # Update configuration file
    sed -i "s/patina_theme=.*$/patina_theme=${patina_theme}/g" "$patina_file_configuration"

    # Refresh the prompt
    export PS1="\\[\\e]2;Patina \\w\\a\\]\\[${patina_major_color}\\]\\u@\\h\\[${color_reset}\\] \\[${patina_minor_color}\\]\\w\\[${color_reset}\\] P\\$ "

  # Failure: Catch any other error condition here
  else
    echo_wrap "Patina has encountered an unknown error."
  fi
}

###########
# Aliases #
###########

# Colors
alias 'p-theme'='patina_theme_apply'

# End of File.
