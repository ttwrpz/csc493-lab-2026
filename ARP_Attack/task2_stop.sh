#!/bin/bash
# Stop the Task 2/3 MITM: kill the poisoner + relay on M, restore IP forwarding.
M=M-10.9.0.105
docker exec $M pkill -f poison_both.py 2>/dev/null
docker exec $M pkill -f mitm.py 2>/dev/null
docker exec $M sysctl -w net.ipv4.ip_forward=1 >/dev/null
echo "MITM stopped, ip_forward restored on M."
