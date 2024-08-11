#!/bin/bash

# !!! - Set up your .env file BEFORE running this script - !!!

# Export all variables from .env.
# This is always going to complain about UID being a read-only variable.
# However that is not a problem and it's necessary for UID to be defined in the .env so that compose.yml can take it.
set -a
source .env
set +a

# Create group and users
sudo groupadd mediacenter -g $MEDIACENTER_GID
sudo useradd rclone -u $RCLONE_UID
sudo useradd sonarr -u $SONARR_UID
sudo useradd radarr -u $RADARR_UID
sudo useradd recyclarr -u $RECYCLARR_UID
sudo useradd prowlarr -u $PROWLARR_UID
sudo useradd overseerr -u $OVERSEERR_UID
sudo useradd plex -u $PLEX_UID
sudo useradd rdtclient -u $RDTCLIENT_UID
sudo useradd autoscan -u $AUTOSCAN_UID

# Adds all the service users to the group.
# When you add the user to the group the changes don't take effect immediately. 
# You can force them by running "sudo newgrp mediacenter" but that won't always work and it's better to just reboot after the script finishes running.
# Adds current user to the mediacenter group. This is recommended so that you can still have access to files inside the folder structure for manual control.
sudo usermod -a -G mediacenter $USER
sudo usermod -a -G mediacenter rclone
sudo usermod -a -G mediacenter sonarr
sudo usermod -a -G mediacenter radarr
sudo usermod -a -G mediacenter recyclarr
sudo usermod -a -G mediacenter prowlarr
sudo usermod -a -G mediacenter overseerr
sudo usermod -a -G mediacenter plex
sudo usermod -a -G mediacenter rdtclient
sudo usermod -a -G mediacenter autoscan

# Create directories.
# ${ROOT_DIR:-.}/ means take the value from ROOT_DIR value, if failed or empty place it in the current folder.
# Application Configuration directories.
sudo mkdir -pv ${ROOT_DIR:-.}/config/{sonarr,radarr,recyclarr,prowlarr,overseerr,plex,rdt,autoscan}-config
# Symlink directories.
sudo mkdir -pv ${ROOT_DIR:-.}/data/symlinks/{radarr,sonarr}
# Location symlinks resolve to.
sudo mkdir -pv ${ROOT_DIR:-.}/data/realdebrid-zurg
# Media folders.
sudo mkdir -pv ${ROOT_DIR:-.}/data/media/{movies,tv}

# Set permissions
# Recursively chmod to 775/664
sudo chmod -R a=,a+rX,u+w,g+w ${ROOT_DIR:-.}/data/
sudo chmod -R a=,a+rX,u+w,g+w ${ROOT_DIR:-.}/config/

sudo chown -R $UID:mediacenter ${ROOT_DIR:-.}/data/
sudo chown -R $UID:mediacenter ${ROOT_DIR:-.}/config/
sudo chown -R sonarr:mediacenter ${ROOT_DIR:-.}/config/sonarr-config
sudo chown -R radarr:mediacenter ${ROOT_DIR:-.}/config/radarr-config
sudo chown -R recyclarr:mediacenter ${ROOT_DIR:-.}/config/recyclarr-config
sudo chown -R prowlarr:mediacenter ${ROOT_DIR:-.}/config/prowlarr-config
sudo chown -R overseerr:mediacenter ${ROOT_DIR:-.}/config/overseerr-config
sudo chown -R plex:mediacenter ${ROOT_DIR:-.}/config/plex-config
sudo chown -R rdtclient:mediacenter ${ROOT_DIR:-.}/config/rdt-config
sudo chown -R autoscan:mediacenter ${ROOT_DIR:-.}/config/autoscan-config

echo "Done! It is recommended to reboot now."
