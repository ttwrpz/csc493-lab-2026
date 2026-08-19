#!/bin/bash
# Task 1.3 -- traceroute to a destination (Linux traceroute command).
read -p "Enter weekly code (e.g. WK01-ASDK): " WK

wk() {
  local G=$'\033[01;32m' B=$'\033[01;34m' R=$'\033[00m'
  local PROMPT_DIRTRIM; PROMPT_DIRTRIM=$(sed -n 's/^[[:space:]]*PROMPT_DIRTRIM=\([0-9]\+\).*/\1/p' ~/.bashrc 2>/dev/null | tail -1)
  local w='\w'; w="${w@P}"
  printf '[%s]%s%s@%s%s:%s%s%s$ echo %s\n' "$(date +%D)" "$G" "$(whoami)" "$(hostname)" "$R" "$B" "$w" "$R" "$WK"
  echo "$WK"
}

traceroute 8.8.8.8
wk
