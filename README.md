# L4D2 Zonemod server deployment scripts

The purpose of these scripts is to deploy a competitive-ready L4D2 Zonemod server. They are not fully production ready or idiot-proof (you need _some_ knowledge about how to run a L4D2 server) but they work (as of March 2025), and since some people asked me to publish them, here they are. PRs are welcome!

## Requirements

- A server with Ubuntu (or any other Debian-based OS), recommended at least 2 decently powerful cores and 2GB RAM for 1 game server.
- Basic Linux and Valve server management knowledge.
- 30 GB free space (mostly taken up by custom maps).

## Usage (read everything first!)

### First time

As `root` user, run:
```
apt update && apt install git -y
git clone https://github.com/robex/l4d2-zm-install-scripts/
cd l4d2-zm-install-scripts
bash install_pre.sh [nsrv] [srvname] [srvloc] [startport]
```
Where the parameters to `install_pre.sh` are:
```
usage: install_pre.sh [nsrv] [srvname] [srvloc] [startport]
       nsrv: number of servers to launch
       srvname: l4d2 server name
       srvloc: server location for l4d2 server name
       startport: starting port
	   custommaps: whether to download custom maps (1 for yes, 0 for no)
```
An example to deploy a single server called "robex - NY" on port 27015 with custom maps would be:
```
bash install_pre.sh 1 "robex" "NY" 27015 1
```
An example to deploy 2 servers called "robex - AU 1" and "robex - AU 2" respectively on ports 30000 and 30001 without custom maps would be:
```
bash install_pre.sh 2 "robex" "AU" 30000 0
```

### Other functionalities

The following examples must be run as `steam` user from the `/home/steam/l4d2-zm-install-scripts/` folder, with the same parameters as the `install_pre.sh` script.

```
# Restart servers
bash restart_l4d2.sh [nsrv] [startport]

# Update L4D2
bash update_l4d2.sh [nsrv] [startport]

# Update Zonemod
bash update_cfgs.sh [nsrv] [srvname] [srvloc] [startport]
```

## Remarks

The scripts will do the following things:
- Create a `steam` user
- Download L4D2 server and L4D2-Competitive rework repo
- Download custom maps if specified
- Add a few extra QoL plugins (fakelag, server_restarter)
- Setup useful symlinks in `/home/steam/` folder (admins_simple.ini, plugins, etc)
- Copy scripts to `/home/steam/l4d2-zm-install-scripts/`

The scripts launch the servers inside `tmux`, familiarize yourself with it if you need to interact with the server console.
