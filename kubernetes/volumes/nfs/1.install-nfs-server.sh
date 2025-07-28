#/bin/bash

# run update
apt update && apt -y upgrade

# install nfs-server
apt install -y nfs-server

# create nfs share
mkdir /data

# nfs configuration file
cat << EOF >> /etc/exports
/data *(rw,no_subtree_check,no_root_squash,insecure)
EOF

# enable the service
systemctl enable --now nfs-server

# export/share directories
exportfs -ar
