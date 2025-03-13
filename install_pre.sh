#!/bin/bash

# usage: install_pre.sh [nsrv] [srvname] [srvloc] [startport]
#        nsrv: number of servers to launch
#        srvname: l4d2 server name
#        srvloc: server location for l4d2 server name
#        startport: starting port
#
# example: ./install_pre.sh 2 robex EU 27015

if [ "$#" -ne 4 ]; then
    echo "read first lines of script for usage"
    exit
fi

# Install prerequisites
echo "Installing prerequisites..."
dpkg --add-architecture i386 # enable multi-arch
apt-get update -y && apt-get upgrade -y
apt-get install -y libc6:i386 # install base 32bit libraries
apt-get install -y lib32z1 unzip wget tmux psmisc sed sudo git 7zip


# Create user account
echo "Creating user 'steam'..."
adduser \
   --shell /bin/bash \
   --gecos 'User for managing l4d2 server' \
   --disabled-password \
   --home /home/steam \
   steam
   
usermod -aG sudo steam

# CentOS 7 version (comment everything above and uncomment below)

#yum -y install glibc.i686
#yum -y update libstdc++
#yum -y install libstdc++.i686
#yum -y lib32z1 unzip wget tmux psmisc sed sudo git

#echo "Creating user 'steam'..."
#adduser \
#   --shell /bin/bash \
#   --home /home/steam \
#   steam


cp -r /root/l4d2-install-scripts /home/steam
chown -R steam:steam /home/steam/l4d2-install-scripts

cp /root/l4d2-install-scripts/server.cfg /home/steam
chown steam:steam /home/steam/server.cfg

echo "Executing install script..."
sudo -i -u steam /bin/sh /home/steam/l4d2-install-scripts/install_l4d2.sh $1 $2 $3 $4
