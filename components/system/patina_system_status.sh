#!/bin/bash

#############
# Variables #
#############

patina_has_systemd=''

#############
# Kickstart #
#############

# Detect 'systemd'
if ( hash 'systemctl' ) ; then
  readonly patina_has_systemd='true'
else
  readonly patina_has_systemd='false'
fi

# End of File.
