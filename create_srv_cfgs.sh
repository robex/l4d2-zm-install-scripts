#!/bin/bash

# Create server.cfg files
for i in $(seq 1 $1)
do
	cp l4d2/cfg/server.cfg l4d2/cfg/server${i}.cfg
	sed -i "s/___SERVNAME___/$2/g" /home/steam/l4d2/cfg/server$i.cfg
	sed -i "s/___SERVLOC___/$3/g" /home/steam/l4d2/cfg/server$i.cfg
	sed -i "s/___SERVNUM___/$i/g" /home/steam/l4d2/cfg/server$i.cfg
	
	ln -s l4d2/cfg/server${i}.cfg server${i}.cfg
done