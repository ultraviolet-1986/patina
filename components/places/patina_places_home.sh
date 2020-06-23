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
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#############
# Variables #
#############

# Patina > Global Variables > Home Folder Locations

export readonly PATINA_PATH_HOME_DESKTOP="$HOME/Desktop"
export readonly PATINA_PATH_HOME_DOCUMENTS="$HOME/Documents"
export readonly PATINA_PATH_HOME_DOWNLOADS="$HOME/Downloads"
export readonly PATINA_PATH_HOME_MUSIC="$HOME/Music"
export readonly PATINA_PATH_HOME_PICTURES="$HOME/Pictures"
export readonly PATINA_PATH_HOME_PUBLIC="$HOME/Public"
export readonly PATINA_PATH_HOME_TEMPLATES="$HOME/Templates"
export readonly PATINA_PATH_HOME_VIDEOS="$HOME/Videos"

###########
# Aliases #
###########

# Patina > Aliases > Home Folder Commands

alias 'home'='patina_open_folder $HOME'

alias 'desktop'='patina_open_folder "$PATINA_PATH_HOME_DESKTOP"'
alias 'documents'='patina_open_folder "$PATINA_PATH_HOME_DOCUMENTS"'
alias 'downloads'='patina_open_folder "$PATINA_PATH_HOME_DOWNLOADS"'
alias 'music'='patina_open_folder "$PATINA_PATH_HOME_MUSIC"'
alias 'pictures'='patina_open_folder "$PATINA_PATH_HOME_PICTURES"'
alias 'public'='patina_open_folder "$PATINA_PATH_HOME_PUBLIC"'
alias 'templates'='patina_open_folder "$PATINA_PATH_HOME_TEMPLATES"'
alias 'videos'='patina_open_folder "$PATINA_PATH_HOME_VIDEOS"'

# End of File.
