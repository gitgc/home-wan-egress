# home-wan-egress
Linux routing configuration for managing the multiple WAN exits used for my home internet access. This project requires a system with three Ethernet NICs and one WiFi connection to fully function, and is intended for the small "roll your own fanless PFSense router" boxes that are increasingly cheap and widely available.

## Setup
This repository assumes a recent Debian version using `netplan` to configure network interfaces, with OpenVPN providing VPN connectivity. See included configuration files for more detail. It is critical to note though that on the host OS, this one-time setup step must be performed to enable IP forwarding, which is otherwise disabled by default on Linux:

```console
    $ echo "1" >  /proc/sys/net/ipv4/ip_forward
```

The OpenVPN systemd service should be enabled so that it loads all `.conf` files at boot to create a connection following power failure.

### Firewall/Routing
The firewall and routing configuration for this project can be applied automatically using the included shell script. As these rules do not typically persist between restarts on Linux, it can be helpful to run this script on every boot automatically.

## NIC Overview
* Ethernet port 1: Provides access to default LAN/WAN and is host system's internet connection.
* Ethernet port 2: Provides exit gateway routing for all machines on the `CIDR_VPN_UK` subnet. All machines on this subnet will have an internet connection exiting in London, allowing all machines on that network to access any UK geo-restricted services.
* Ethernet port 3: Provides cellular failover. This is used as secondary WAN connection on main router, and routes all traffic to WLAN interface.
* WLAN Connection: Connect to a cellphone's hotspot, or 4G modem. This will be shared via Ethernet port 3 for use as backup WAN connection.
