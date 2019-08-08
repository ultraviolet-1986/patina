#!/usr/bin/env bash

patina_refresh_firefox() {
  # Variables
  readonly patina_firefox_archive_name='Patina_Firefox_Latest_x64.tar.bz2'

  # Unmount previous disk image
  if [ -d "/run/media/$USER/Firefox" ] && [ -f "$HOME/Downloads/patina_firefox.iso" ] ; then
    umount "$HOME/Downloads/patina_firefox.iso"
    rm "$HOME/Downloads/patina_firefox.iso"
  fi

  # Change to /tmp directory.
  cd /tmp || return

  # Download Latest Firefox Linux build (64-Bit).
  wget -O \
    "$patina_firefox_archive_name" \
    'https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-GB'

  tar -xvjf "$patina_firefox_archive_name"

  # Create ISO disk image.
  mkisofs -volid "Firefox" -o "patina_firefox.iso" -input-charset UTF-8 -joliet \
    -joliet-long -rock "firefox"

  mv 'patina_firefox.iso' "$HOME/Downloads/patina_firefox.iso"

  rm -rf "$patina_firefox_archive_name" 'firefox'

  # Return to original directory.
  cd ~- || return

  #gnome-disk-image-mounter "$HOME/Downloads/patina_firefox.iso"
}

patina_run_firefox_disk_image() {
  if [ ! -d "/run/media/$USER/Firefox" ] && [ -f "$HOME/Downloads/patina_firefox.iso" ] ; then
    gnome-disk-image-mounter "$HOME/Downloads/patina_firefox.iso"
    /run/media/$USER/Firefox/firefox
    wait
    umount "$HOME/Downloads/patina_firefox.iso"
  elif [ -d "/run/media/$USER/Firefox" ] && [ -f "$HOME/Downloads/patina_firefox.iso" ] ; then
    /run/media/$USER/Firefox/firefox
    wait
    umount "$HOME/Downloads/patina_firefox.iso"
  fi
}

alias 'p-firefox-refresh'='patina_refresh_firefox'
alias 'p-firefox'='patina_run_firefox_disk_image'

# End of File.
