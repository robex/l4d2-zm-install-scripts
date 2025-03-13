#!/bin/bash

# usage: restart_l4d2.sh [nsrv] [startport]
#        nsrv: number of servers to launch
#        startport: starting port

cd /home/steam

tmux kill-server
sleep 2

bash l4d2-zm-install-scripts/run_l4d2.sh $1 $2