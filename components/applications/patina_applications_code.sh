#!/usr/bin/env bash

patina_visual_studio_code() {
  if [ ! "$1" ] ; then
    patina_launch_code_disk_image
  elif [ "$1" = 'refresh' ] ; then
    patina_create_code_disk_image
  elif [ "$1" = 'mount' ] ; then
    patina_mount_code_disk_image
  elif [ "$1" = 'disconnect' ] ; then
    umount "$HOME/Downloads/patina_vscode.iso"
  fi
}

patina_create_code_disk_image() {
  # Prerequisite: Detect an Internet connection.
  patina_detect_internet_connection

  # Success: Patina has detected an active Internet connection.
  if [ "$patina_has_internet" = 'true' ] ; then
    # Change directory to /tmp.
    cd /tmp || return

    # Download latest Visual Studio Code (Stable) tarball from Microsoft.
    wget -O "patina_code_stable_latest.tar.gz" \
      "https://update.code.visualstudio.com/latest/linux-x64/stable"

    # Extract contents of the downloaded archive.
    tar -xvzf "patina_code_stable_latest.tar.gz"

    # Create ISO disk image.
    mkisofs -volid "VSCode" -o "patina_vscode.iso" -input-charset UTF-8 -joliet \
      -joliet-long -rock "VSCode-linux-x64"

    # Move disk image to $HOME directory.
    mv "/tmp/patina_vscode.iso" "$HOME/Downloads/patina_vscode.iso"

    # Cleanup archive and folder.
    rm -rf "/tmp/patina_code_stable_latest.tar.gz" "/tmp/VSCode-linux-x64"

    # Return to original directory.
    cd ~- || return

  # Failure: Patina has not detected an active Internet connection.
  elif [ "$patina_has_internet" = 'false' ] ; then
    patina_throw_exception 'PE0008'

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi
}

patina_launch_code_disk_image() {
  patina_mount_code_disk_image

  if [ -f "/run/media/$USER/VSCode/bin/code" ] ; then
    "/run/media/$USER/VSCode/bin/code"
  fi
}

patina_mount_code_disk_image() {
  # Failure: ISO disk image does not exist.
  if [ ! -f "$HOME/Downloads/patina_vscode.iso" ] ; then
    patina_throw_exception 'PE0005'

  # Failure: Disk image is already mounted.
  elif [ -f "$HOME/Downloads/patina_vscode.iso" ] && [ -d "/run/media/$USER/VSCode" ] ; then
    patina_throw_exception 'PE0012'

  # Success: Mount ISO disk image.
  elif [ -f "$HOME/Downloads/patina_vscode.iso" ] && [ ! -d "/run/media/$USER/VSCode" ] ; then
    gnome-disk-image-mounter "$HOME/Downloads/patina_vscode.iso"

  # Failure: Catch all.
  else
    patina_throw_exception 'PE0000'
  fi
}

###########
# Aliases #
###########

alias 'p-code'='patina_visual_studio_code'

# End of File.
