# home-wan-egress
Linux routing configuration for managing the multiple WAN exits used for my home internet access. This project requires a physical system with three Ethernet NICs and one WiFi connection to fully function, and is intended for the small "roll your own fanless PFSense router" boxes that are increasingly cheap and widely available.

## Setup
This repository assumes a recent Debian distro using `netplan` to configure network interfaces, with OpenVPN providing VPN connectivity. See included configuration files for more detail. It is critical to note though that on the host OS, this one-time setup step must be performed to enable IP forwarding, which is otherwise disabled by default on Linux:

```console
    $ echo "1" >  /proc/sys/net/ipv4/ip_forward
```

The OpenVPN systemd service should be enabled so that it loads all `.conf` files at boot to create a connection following power failure.

### Firewall/Routing
The firewall and routing configuration for this project can be applied automatically using the included shell script. As these rules do not typically persist between restarts on Linux, it can be helpful to run this script on every boot automatically.

### Using an iPhone Hotspot USB Connection
If using an iPhone via USB as backup WAN, you must install the following additional dependencies:

```console
    $ apt install ipheth-utils libimobiledevice-dev libimobiledevice-utils
```

to support USB ethernet connection via the iPhone. After doing so, you should be able to find the iPhone as an additional adapter listed via the `ifconfig -a` command. Take the name of the NIC, and configure it as an ethernet adapter as normal in `netplan`. See included example for how to bridge USB iPhone hotspot to an ethernet port on the box.

## NIC Overview
* Ethernet port 1: Provides access to default LAN/WAN and is host system's internet connection.
* Ethernet port 2: Provides exit gateway routing for all machines on the 10.0.0.0/28 subnet I use for devices requiring UK internet connection. All machines on this subnet will have an internet connection exiting in London, allowing all machines on that network to access any UK geo-restricted services.
* Ethernet port 3: Provides cellular failover. This is used as secondary WAN connection on main router, and routes all traffic to tethered USB  iPhone interface.
* USB Ethernet: iPhone tethering via Lightning cable. This connection will be re-shared on Ethernet Port 3 as the backup WAN connection.
