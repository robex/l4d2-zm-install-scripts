#!/bin/bash

# Start server(s)

for i in $(seq 1 $1)
do
	tmux new-session -s srv$i -d "/home/steam/Steam/steamapps/common/l4d2/srcds_run -game left4dead2 -port "$(($2+$i-1))" +sv_clockcorrection_msecs 25 -timeout 10 -tickrate 100 +map c9m1_alleys -maxplayers 16 +servercfgfile server"${i}".cfg"
done
