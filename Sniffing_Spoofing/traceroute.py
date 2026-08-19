#!/usr/bin/env python3
from scapy.all import *
import sys

ttl = int(sys.argv[1]) if len(sys.argv) > 1 else 1
a = IP(dst='8.8.8.8', ttl=ttl)
b = ICMP()
send(a/b)
