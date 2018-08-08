#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2018 William Willis Whinn

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
