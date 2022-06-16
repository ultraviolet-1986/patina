#!/usr/bin/env bash

###########
# License #
###########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2022 William Willis Whinn

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

#############
# Variables #
#############

PATINA_PATH_HOME_DESKTOP="${HOME}/Desktop"
readonly PATINA_PATH_HOME_DESKTOP
export PATINA_PATH_HOME_DESKTOP

PATINA_PATH_HOME_DOCUMENTS="${HOME}/Documents"
readonly PATINA_PATH_HOME_DOCUMENTS
export PATINA_PATH_HOME_DOCUMENTS

PATINA_PATH_HOME_DOWNLOADS="${HOME}/Downloads"
readonly PATINA_PATH_HOME_DOWNLOADS
export PATINA_PATH_HOME_DOWNLOADS

PATINA_PATH_HOME_MUSIC="${HOME}/Music"
readonly PATINA_PATH_HOME_MUSIC
export PATINA_PATH_HOME_MUSIC

PATINA_PATH_HOME_PICTURES="${HOME}/Pictures"
readonly PATINA_PATH_HOME_PICTURES
export PATINA_PATH_HOME_PICTURES

PATINA_PATH_HOME_PUBLIC="${HOME}/Public"
readonly PATINA_PATH_HOME_PUBLIC
export PATINA_PATH_HOME_PUBLIC

PATINA_PATH_HOME_TEMPLATES="${HOME}/Templates"
readonly PATINA_PATH_HOME_TEMPLATES
export PATINA_PATH_HOME_TEMPLATES

PATINA_PATH_HOME_VIDEOS="${HOME}/Videos"
readonly PATINA_PATH_HOME_VIDEOS
export PATINA_PATH_HOME_VIDEOS

###########
# Aliases #
###########

alias 'home'='patina_open_folder ${HOME}'

alias 'desktop'='patina_open_folder "${PATINA_PATH_HOME_DESKTOP}"'
alias 'documents'='patina_open_folder "${PATINA_PATH_HOME_DOCUMENTS}"'
alias 'downloads'='patina_open_folder "${PATINA_PATH_HOME_DOWNLOADS}"'
alias 'music'='patina_open_folder "{$PATINA_PATH_HOME_MUSIC}"'
alias 'pictures'='patina_open_folder "${PATINA_PATH_HOME_PICTURES}"'
alias 'public'='patina_open_folder "${PATINA_PATH_HOME_PUBLIC}"'
alias 'templates'='patina_open_folder "${PATINA_PATH_HOME_TEMPLATES}"'
alias 'videos'='patina_open_folder "${PATINA_PATH_HOME_VIDEOS}"'

# End of File.
