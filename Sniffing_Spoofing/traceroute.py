#!/usr/bin/env python3
# Task 1.3 -- estimate the number of routers to a destination (TTL sweep).
# usage: sudo python3 traceroute.py [dst]
import sys
from scapy.all import *

dst = sys.argv[1] if len(sys.argv) > 1 else '8.8.8.8'
print(f"[traceroute] to {dst}")

for ttl in range(1, 31):
    reply = sr1(IP(dst=dst, ttl=ttl)/ICMP(), timeout=2, verbose=0)
    if reply is None:
        print(f"{ttl:2d}  *")
    elif reply.type == 0:                 # echo reply -> reached destination
        print(f"{ttl:2d}  {reply.src}  <-- destination reached")
        break
    else:                                 # type 11 time-exceeded -> a router
        print(f"{ttl:2d}  {reply.src}")
