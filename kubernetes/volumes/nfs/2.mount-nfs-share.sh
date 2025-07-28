#!/bin/bash

# run update and install nfs client
sudo apt update && sudo apt install nfs-common

sudo mkdir /var/data

# mount nfs share ( update the nfs-server-ip as per your environment )
sudo mount -t nfs -o nfsvers=3 <nfs-server-ip>:/data /var/data
