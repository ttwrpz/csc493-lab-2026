#!/bin/bash
# Task 1.3 -- traceroute with Scapy (count routers to a destination).
# Run from ~/SeedLabs/Sniffing_Spoofing/ :  ./task1_3.sh [dst]
set -u
cd "$(dirname "$0")" || exit 1

read -p "Enter weekly code (e.g. WK01-ASDK): " WK

DST="${1:-8.8.8.8}"
echo "Tracing route to $DST"
echo
sudo python3 traceroute.py "$DST"

echo
echo "$WK"
