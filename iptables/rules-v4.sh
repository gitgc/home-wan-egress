#!/bin/bash

iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# UK VPN exit routing
iptables -A FORWARD -i enp2s0 -o tun0 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.0.0.0/28 ! -d 10.0.0.0/28 -o tun0 -j MASQUERADE
ip rule add from 10.0.0.0/28 table 99
ip route add 0.0.0.0/0 via "${IP_VPN_UK}" dev tun0 table 99
