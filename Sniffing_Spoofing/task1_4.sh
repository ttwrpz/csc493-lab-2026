#!/bin/bash
# Task 1.4 -- sniff-and-then-spoof: sniff ICMP echo requests, forge echo replies.
# Run from ~/csc493-lab-2026/Sniffing_Spoofing/ :  ./task1_4.sh
set -u
cd "$(dirname "$0")" || exit 1

read -p "Enter weekly code (e.g. WK01-ASDK): " WK

wk() {
  local G=$'\033[01;32m' B=$'\033[01;34m' R=$'\033[00m'
  local dir="$PWD"; [ "${dir#$HOME}" != "$dir" ] && dir="~${dir#$HOME}"
  printf '[%s]%s%s@%s%s:%s%s%s$ echo %s\n' "$(date +%D)" "$G" "$(whoami)" "$(hostname)" "$R" "$B" "$dir" "$R" "$WK"
  echo "$WK"
}

IFACE=$(ip -o -4 addr show | awk '$4 ~ /^10\.9\.0\.1\// {print $2; exit}')
[ -z "${IFACE:-}" ] && { echo "bridge 10.9.0.1 not found, is dcup running?"; exit 1; }
HOSTA=$(docker ps -qf "name=hostA")
echo "Interface: $IFACE   hostA container: ${HOSTA:-not found}"

echo
echo "Starting sniff-and-spoof for ~25s (background)"
sudo python3 sniff_spoof.py "$IFACE" 25 &
SPID=$!
sleep 2

for t in 1.2.3.4 10.9.0.99 8.8.8.8; do
  echo
  echo "hostA pings $t"
  docker exec "$HOSTA" ping -c 3 -W 2 "$t" 2>&1
done

wait "$SPID" 2>/dev/null
echo
wk
