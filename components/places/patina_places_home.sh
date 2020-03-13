#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

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

#############
# Variables #
#############

export readonly patina_path_home_desktop="$HOME/Desktop"
export readonly patina_path_home_documents="$HOME/Documents"
export readonly patina_path_home_downloads="$HOME/Downloads"
export readonly patina_path_home_music="$HOME/Music"
export readonly patina_path_home_pictures="$HOME/Pictures"
export readonly patina_path_home_public="$HOME/Public"
export readonly patina_path_home_templates="$HOME/Templates"
export readonly patina_path_home_videos="$HOME/Videos"

###########
# Aliases #
###########

alias 'home'='patina_open_folder $HOME'

alias 'desktop'='patina_open_folder "$patina_path_home_desktop"'
alias 'documents'='patina_open_folder "$patina_path_home_documents"'
alias 'downloads'='patina_open_folder "$patina_path_home_downloads"'
alias 'music'='patina_open_folder "$patina_path_home_music"'
alias 'pictures'='patina_open_folder "$patina_path_home_pictures"'
alias 'public'='patina_open_folder "$patina_path_home_public"'
alias 'templates'='patina_open_folder "$patina_path_home_templates"'
alias 'videos'='patina_open_folder "$patina_path_home_videos"'

# End of File.
