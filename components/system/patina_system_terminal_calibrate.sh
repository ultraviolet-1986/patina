#!/usr/bin/env bash

##############
# Directives #
##############

# Some items are defined elsewhere
# shellcheck disable=SC2154

#############
# Functions #
#############

patina_calibrate_terminal_draw_columns() {
  for (( i=1; i <= width; ++i )) ; do
    printf "#"
  done
  printf "\\n"
}

patina_calibrate_terminal_draw_rows() {
  printf "%b" "${patina_minor_color}"
  for (( j=2; j <= height; ++j )) ; do
    patina_calibrate_terminal_draw_columns
  done
  printf "%b" "${color_reset}"
}

patina_calibrate_terminal_window() {
  # Define terminal dimensions
  local width="$1"
  local height="$2"

  # Create regular expression
  local number='^[0-9]+$'

  # Failure: One or both of the required arguments are null or not numbers
  if ! [[ $width =~ $number ]] || ! [[ $height =~ $number ]] ; then
    echo_wrap "The 'p-calibrate' command requires two numerical arguments, e.g.: 'p-calibrate 80 24'."

  # Failure: One or both of the arguments are '0'
  elif [[ $width = "0" ]] || [[ $height = "0" ]] ; then
    echo_wrap "The 'p-calibrate' command requires two numerical arguments which are greater than zero, e.g.: 'p-calibrate 80 24'."

  # Failure: Arguments are out-of-range
  elif [[ $width -lt 80 || $width -gt 300 ]] || [[ $height -lt 24 || $height -gt 300 ]] ; then
    echo_wrap "The 'p-calibrate' command supports a minimum size of 80x24 characters and a maximum of 300x300 characters."

  # Success: Both arguments exist and are numeric
  elif [[ $width =~ $number && $width -gt 0 ]] && [[ $height =~ $number && $height -gt 0 ]] ; then
    reset
    patina_calibrate_terminal_draw_rows

  # Failure: Catch any other error condition here
  else
    echo_wrap "Patina has encountered an unknown error."
  fi

  # Cleanup local variables after use
  unset -v width height number
}

###########
# Aliases #
###########

alias 'p-calibrate'='patina_calibrate_terminal_window'

# End of File.
