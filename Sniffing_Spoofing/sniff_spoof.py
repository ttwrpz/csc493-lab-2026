#!/usr/bin/env python3
# Task 1.4 -- sniff ICMP echo requests, then send a spoofed echo reply.
# usage: sudo python3 sniff_spoof.py <iface> [timeout-seconds]
import sys
from scapy.all import *

iface   = sys.argv[1] if len(sys.argv) > 1 else None
timeout = int(sys.argv[2]) if len(sys.argv) > 2 else None

def spoof_reply(pkt):
    if ICMP in pkt and pkt[ICMP].type == 8:      # echo request only
        src, dst = pkt[IP].src, pkt[IP].dst
        print(f"Sniffed request : {src} -> {dst}")
        ip   = IP(src=dst, dst=src, ihl=pkt[IP].ihl)
        icmp = ICMP(type=0, id=pkt[ICMP].id, seq=pkt[ICMP].seq)
        data = pkt[Raw].load if Raw in pkt else b''
        send(ip/icmp/data, verbose=0)
        print(f"Spoofed reply   : {dst} -> {src}")

msg = f"[sniff-spoof] iface={iface}"
msg += f"  timeout={timeout}s" if timeout else "  (press Ctrl+C to stop)"
print(msg)
# capture only echo requests, so we never see our own spoofed replies
sniff(iface=iface, filter='icmp and icmp[icmptype]=8', prn=spoof_reply, timeout=timeout)
