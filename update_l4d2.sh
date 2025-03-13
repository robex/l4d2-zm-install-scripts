#!/bin/bash

# usage: update_l4d2.sh [nsrv] [startport]
#        nsrv: number of servers to launch
#        startport: starting port -1 (so if you want 27015, put 27014 here)

cd /home/steam

tmux kill-server

# update base game
./steamcmd.sh +force_install_dir ./Steam/steamapps/common/l4d2 +login anonymous +@sSteamCmdForcePlatformType windows +app_update 222860 validate +quit && \
./steamcmd.sh +force_install_dir ./Steam/steamapps/common/l4d2 +login anonymous +@sSteamCmdForcePlatformType linux  +app_update 222860 validate +quit

bash l4d2-zm-install-scripts/run_l4d2.sh $1 $2