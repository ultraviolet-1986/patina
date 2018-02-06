#!/usr/bin/env bash

#############
# Variables #
#############

readonly patina_path_home_desktop="$HOME/[Dd][Ee][Ss][Kk][Tt][Oo][Pp]"
readonly patina_path_home_documents="$HOME/[Dd][Oo][Cc][Uu][Mm][Ee][Nn][Tt][Ss]"
readonly patina_path_home_downloads="$HOME/[Dd][Oo][Ww][Nn][Ll][Oo][Aa][Dd][Ss]"
readonly patina_path_home_music="$HOME/[Mm][Uu][Ss][Ii][Cc]"
readonly patina_path_home_pictures="$HOME/[Pp][Ii][Cc][Tt][Uu][Rr][Ee][Ss]"
readonly patina_path_home_public="$HOME/[Pp][Uu][Bb][Ll][Ii][Cc]"
readonly patina_path_home_templates="$HOME/[Tt][Ee][Mm][Pp][Ll][Aa][Tt][Ee][Ss]"
readonly patina_path_home_videos="$HOME/[Vv][Ii][Dd][Ee][Oo][Ss]"

###########
# Aliases #
###########

alias 'home'='patina_open_folder $HOME'

alias 'desktop'='patina_open_folder $patina_path_home_desktop'
alias 'documents'='patina_open_folder $patina_path_home_documents'
alias 'downloads'='patina_open_folder $patina_path_home_downloads'
alias 'music'='patina_open_folder $patina_path_home_music'
alias 'pictures'='patina_open_folder $patina_path_home_pictures'
alias 'public'='patina_open_folder $patina_path_home_public'
alias 'templates'='patina_open_folder $patina_path_home_templates'
alias 'videos'='patina_open_folder $patina_path_home_videos'

# End of File.
