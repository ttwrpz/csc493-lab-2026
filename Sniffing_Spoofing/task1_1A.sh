#!/bin/bash
# Task 1.1A -- sniffing needs root privilege (non-root fails, root works)
# Run from ~/csc493-lab-2026/Sniffing_Spoofing/ :  ./task1_1A.sh
set -u
cd "$(dirname "$0")" || exit 1

read -p "Enter weekly code (e.g. WK01-ASDK): " WK

wk() {
  local G=$'\033[01;32m' B=$'\033[01;34m' R=$'\033[00m'
  printf '[%s]%s%s@%s%s:%s%s%s$ echo %s\n' "$(date +%D)" "$G" "$(whoami)" "$(hostname)" "$R" "$B" "${PWD/#$HOME/~}" "$R" "$WK"
  echo "$WK"
}

IFACE=$(ip -o -4 addr show | awk '$4 ~ /^10\.9\.0\.1\// {print $2; exit}')
if [ -z "${IFACE:-}" ]; then
  echo "bridge 10.9.0.1 not found, is dcup running?"; exit 1
fi
HOSTA=$(docker ps -qf "name=hostA")
echo "Interface: $IFACE   hostA container: ${HOSTA:-not found}"
echo

echo "[1/2] Sniff without root (expected to fail)"
python3 sniffer.py "$IFACE" icmp 5
echo "exit status: $?"
echo

echo "[2/2] Sniff with root (sudo)"
( sleep 2; docker exec "$HOSTA" ping -c 3 10.9.0.6 >/dev/null 2>&1 ) &
sudo python3 sniffer.py "$IFACE" icmp 8

echo
wk
