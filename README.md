# SEED Security Labs

My work for the SEED labs on the Ubuntu 20.04 VM. Right now this holds the
Packet Sniffing and Spoofing lab.

## Sniffing and Spoofing (Task 1.1 to 1.4)

The scripts live in `Sniffing_Spoofing/`. Each task is a small wrapper that asks
for the weekly code first, runs the task, then prints the code again at the end so
it shows up in the screenshot.

### Setup (on the SEED VM)

```
cd Sniffing_Spoofing
wget --no-check-certificate https://seedsecuritylabs.org/Labs_20.04/Files/Sniffing_Spoofing/Labsetup.zip
unzip Labsetup.zip
cd Labsetup && dcbuild && dcup
```

`dcup` starts three containers: an attacker on the host network, plus hostA
(10.9.0.5) and hostB (10.9.0.6). Leave it running in its own terminal.

### Run the tasks (from another terminal)

```
cd Sniffing_Spoofing
./task1_1A.sh   # sniffing needs root, shows the non root fail then a root capture
./task1_1B.sh   # three filters: icmp, tcp to port 23, and a subnet
./task1_2.sh    # spoof an ICMP echo request with a fake source IP
./task1_3.sh    # scapy traceroute, counts the routers to a target
./task1_4.sh    # sniff echo requests and answer with spoofed replies
```

The `.py` files are helpers used by the wrappers, so run the `.sh` scripts and not
the Python directly. The sniff interface (the bridge that holds 10.9.0.1) is found
for you automatically.

Tested on the SEED 20.04 VM.
