#!/bin/bash
# Task 1.1B -- capturing packets with BPF filters
# Run from ~/csc493-lab-2026/Sniffing_Spoofing/ :  ./task1_1B.sh
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

IFACE=$(ip -o -4 addr show | awk '$4 ~ /^10\.9\.0\.1\// {print $2; exit}')
if [ -z "${IFACE:-}" ]; then
  echo "bridge 10.9.0.1 not found, is dcup running?"; exit 1
fi
HOSTA=$(docker ps -qf "name=hostA")
echo "Interface: $IFACE   hostA container: ${HOSTA:-not found}"

run_filter () {   # $1=title  $2=bpf-filter  $3=traffic-command
  echo
  echo "$1"
  echo "filter = $2"
  ( sleep 2; eval "$3" >/dev/null 2>&1 ) &
  sudo python3 sniffer.py "$IFACE" "$2" 10
  wk
}

run_filter "Filter 1: ICMP only" \
  "icmp" \
  "docker exec $HOSTA ping -c 3 10.9.0.6"

run_filter "Filter 2: TCP from 10.9.0.5 to destination port 23" \
  "tcp and src host 10.9.0.5 and dst port 23" \
  "docker exec $HOSTA bash -c 'echo quit | timeout 3 telnet 10.9.0.6 23'"

run_filter "Filter 3: any packet to or from subnet 128.230.0.0/16" \
  "net 128.230.0.0/16" \
  "docker exec $HOSTA ping -c 3 -W 1 128.230.0.1"
