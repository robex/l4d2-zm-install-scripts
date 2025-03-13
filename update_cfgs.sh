#!/bin/bash

# usage: update_cfgs.sh [nsrv] [srvname] [srvloc] [startport]
#        nsrv: number of servers to launch
#        srvname: l4d2 server name
#        srvloc: server location for l4d2 server name
#        startport: starting port

cd /home/steam

tmux kill-server

# Install files from the rework repository
git -C L4D2-Competitive-Rework/ pull
cp -r L4D2-Competitive-Rework/* l4d2/

cp l4d2-zm-install-scripts/server.cfg l4d2/cfg/

# Create server.cfg files
bash l4d2-zm-install-scripts/create_srv_cfgs.sh $1 $2 $3

bash l4d2-zm-install-scripts/run_l4d2.sh $1 $4