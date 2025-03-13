#!/bin/bash

cd /home/steam

# Install base game
wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
tar -xvzf steamcmd_linux.tar.gz
./steamcmd.sh +force_install_dir ./Steam/steamapps/common/l4d2 +login anonymous +@sSteamCmdForcePlatformType windows +app_update 222860 validate +quit && \
./steamcmd.sh +force_install_dir ./Steam/steamapps/common/l4d2 +login anonymous +@sSteamCmdForcePlatformType linux  +app_update 222860 validate +quit

# Setup main l4d2 shortcut
ln -s Steam/steamapps/common/l4d2/left4dead2/ l4d2

# Install files from the rework repository
git clone https://github.com/SirPlease/L4D2-Competitive-Rework.git
cp -r L4D2-Competitive-Rework/* l4d2/

# Install extras (fakelag)
cp -r l4d2-install-scripts/extras/addons l4d2/

echo "sm plugins load fakelag.smx" >> ~/l4d2/cfg/sharedplugins.cfg
echo "sm plugins load l4d2_server_restarter.smx" >> ~/l4d2/cfg/sharedplugins.cfg

# Setup useful shortcuts
ln -s l4d2/addons/sourcemod/configs/admins_simple.ini admins_simple.ini
ln -s l4d2/addons/sourcemod/plugins/ plugins
ln -s l4d2/addons/sourcemod/configs/matchmodes.txt matchmodes.txt

cp /home/steam/server.cfg /home/steam/l4d2/cfg/server.cfg

# Create server.cfg files
sh l4d2-install-scripts/create_srv_cfgs.sh $1 $2 $3

# Download custom maps (uncomment if wanted, requires around 20GB disk space)
sh l4d2-install-scripts/install_custom_maps.sh

sh l4d2-install-scripts/run_l4d2.sh $1 $4
