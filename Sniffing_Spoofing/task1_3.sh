#!/bin/bash
# Task 1.3 -- traceroute to a destination (Linux traceroute command).
read -p "Enter weekly code (e.g. WK01-ASDK): " WK

wk() {
  local G=$'\033[01;32m' B=$'\033[01;34m' R=$'\033[00m'
  printf '[%s]%s%s@%s%s:%s%s%s$ echo %s\n' "$(date +%D)" "$G" "$(whoami)" "$(hostname)" "$R" "$B" "${PWD/#$HOME/~}" "$R" "$WK"
  echo "$WK"
}

traceroute 8.8.8.8
wk
