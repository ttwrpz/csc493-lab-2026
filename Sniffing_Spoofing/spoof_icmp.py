#!/usr/bin/env python3
# Task 1.2 -- spoof an ICMP echo request with a forged source IP.
# usage: sudo python3 spoof_icmp.py [dst] [forged-src]
import sys
from scapy.all import *

dst = sys.argv[1] if len(sys.argv) > 1 else '10.9.0.6'
src = sys.argv[2] if len(sys.argv) > 2 else '1.2.3.4'

pkt = IP(src=src, dst=dst)/ICMP()
print(f"[spoof] ICMP echo request  src={src}  ->  dst={dst}")
pkt.show()
send(pkt, verbose=1)
