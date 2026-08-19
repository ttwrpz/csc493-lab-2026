#!/bin/bash
# Task 1.2 -- spoof an ICMP echo request with a forged source IP.
# Run from ~/csc493-lab-2026/Sniffing_Spoofing/ :  ./task1_2.sh [dst] [forged-src]
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
TARGET="${1:-10.9.0.6}"     # who we ping
SPOOF="${2:-1.2.3.4}"       # forged source IP
echo "Interface: $IFACE   target=$TARGET   forged src=$SPOOF"

echo
echo "Capturing ICMP on $IFACE (tcpdump, 6s) while sending the spoofed request"
sudo timeout 6 tcpdump -i "$IFACE" -n -c 6 icmp &
TCPD=$!
sleep 1
sudo python3 spoof_icmp.py "$TARGET" "$SPOOF"
wait "$TCPD" 2>/dev/null

echo
wk
