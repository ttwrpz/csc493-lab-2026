#!/bin/bash
# Task 1.1A -- sniffing needs root privilege (non-root fails, root works)
# Run from ~/SeedLabs/Sniffing_Spoofing/ :  ./task1_1A.sh
set -u
cd "$(dirname "$0")" || exit 1

read -p "Enter weekly code (e.g. WK01-ASDK): " WK

IFACE=$(ip -o -4 addr show | awk '$4 ~ /^10\.9\.0\.1\// {print $2; exit}')
if [ -z "${IFACE:-}" ]; then
  echo "!! Could not find the 10.9.0.1 bridge. Is 'dcup' running?"; exit 1
fi
HOSTA=$(docker ps -qf "name=hostA")
echo "Interface: $IFACE   hostA container: ${HOSTA:-<not found>}"
echo

echo "=================================================="
echo " [1/2] Sniff WITHOUT root  ->  expected to FAIL"
echo "=================================================="
python3 sniffer.py "$IFACE" icmp 5
echo "   (exit status: $?  -- permission denied means the demo worked)"
echo

echo "=================================================="
echo " [2/2] Sniff WITH root (sudo)  ->  should capture"
echo "=================================================="
( sleep 2; docker exec "$HOSTA" ping -c 3 10.9.0.6 >/dev/null 2>&1 ) &
sudo python3 sniffer.py "$IFACE" icmp 8

echo
echo "=================================================="
echo " Task 1.1A done.     Weekly code: $WK"
echo "=================================================="
echo "$WK"
