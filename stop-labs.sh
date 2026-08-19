#!/bin/bash
# Stop all running SEED lab docker containers.
# Runs docker-compose down for every Labsetup in this repo, then stops any
# remaining running containers. Safe to run from anywhere.
set -u
REPO="$(cd "$(dirname "$0")" && pwd)"

echo "Tearing down labs found in the repo..."
found=0
for comp in "$REPO"/*/Labsetup/docker-compose.yml; do
  [ -f "$comp" ] || continue
  found=1
  dir="$(dirname "$comp")"
  echo "  docker-compose down: $dir"
  ( cd "$dir" && docker-compose down )
done
[ "$found" -eq 0 ] && echo "  (no */Labsetup/docker-compose.yml in the repo)"

running="$(docker ps -q)"
if [ -n "$running" ]; then
  echo "Stopping remaining running containers..."
  docker stop $running
fi

echo
echo "Now running:"
docker ps
