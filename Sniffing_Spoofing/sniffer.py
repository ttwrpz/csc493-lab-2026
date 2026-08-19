#!/usr/bin/env python3
# Task 1.1 sniffer, parameterized so the task wrappers can drive it.
# usage: sudo python3 sniffer.py <iface> [bpf-filter] [timeout-seconds]
#   <iface>            interface to sniff (the br-... with IP 10.9.0.1)
#   [bpf-filter]       BPF string, default 'icmp'
#   [timeout-seconds]  stop after N seconds; omit to run until Ctrl+C
import sys
from scapy.all import *

iface   = sys.argv[1] if len(sys.argv) > 1 else None
bpf     = sys.argv[2] if len(sys.argv) > 2 else 'icmp'
timeout = int(sys.argv[3]) if len(sys.argv) > 3 else None

def print_pkt(pkt):
    pkt.show()

info = f"[sniffer] iface={iface}  filter={bpf!r}"
info += f"  timeout={timeout}s" if timeout else "  (press Ctrl+C to stop)"
print(info)

pkts = sniff(iface=iface, filter=bpf, prn=print_pkt, timeout=timeout)
print(f"[sniffer] captured {len(pkts)} packet(s)")
