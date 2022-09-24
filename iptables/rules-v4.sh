#!/bin/bash

iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# UK VPN exit routing
iptables -A FORWARD -i "${NIC_VPN_UK}" -o "${TUNNEL_VPN_UK}" -j ACCEPT
iptables -t nat -A POSTROUTING -s "${CIDR_VPN_UK}" ! -d "${CIDR_VPN_UK}" -o "${TUNNEL_VPN_UK}" -j MASQUERADE
ip rule add from "${CIDR_VPN_UK}" table 99
ip route add 0.0.0.0/0 via "${IP_VPN_UK}" dev "${TUNNEL_VPN_UK}" table 99

# Cellular backup exit routing
