#!/usr/bin/env bash

##########
# Notice #
##########

# Patina: A 'patina', 'layer', or 'toolbox' for BASH under Linux.
# Copyright (C) 2020 William Willis Whinn

# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.

# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with
# this program. If not, see <http://www.gnu.org/licenses/>.

#############
# Functions #
#############

patina_checksum_recursive() {
  shopt -s globstar dotglob
  "$1" ./** > "${PWD##*/}.$1"
}

###########
# Exports #
###########

export -f 'patina_checksum_recursive'

###########
# Aliases #
###########

alias 'p-md5sum'="patina_checksum_recursive 'md5sum'"
alias 'p-sha1sum'="patina_checksum_recursive 'sha1sum'"
alias 'p-sha256sum'="patina_checksum_recursive 'sha256sum'"
alias 'p-sha384sum'="patina_checksum_recursive 'sha384sum'"
alias 'p-sha512sum'="patina_checksum_recursive 'sha512sum'"

# End of File.
