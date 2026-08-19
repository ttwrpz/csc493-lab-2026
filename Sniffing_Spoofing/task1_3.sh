#!/bin/bash
# Task 1.3 -- Scapy traceroute (SEED manual style): set the TTL, send one ICMP packet.
# Bump the TTL and run again; watch the reply with Wireshark or tcpdump.
# usage: ./task1_3.sh <ttl>      e.g. ./task1_3.sh 3
read -p "Enter weekly code (e.g. WK01-ASDK): " WK
cd "$(dirname "$0")"
sudo python3 traceroute.py "${1:-1}"
echo "$WK"
