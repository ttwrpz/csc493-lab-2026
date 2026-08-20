# SEED Security Labs

My work for the SEED labs on the Ubuntu 20.04 VM. Right now this holds the
Packet Sniffing and Spoofing lab and the ARP Cache Poisoning lab.

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

## ARP Cache Poisoning (Task 1 and MITM)

The scripts live in `ARP_Attack/`. Three hosts share the 10.9.0.0/24 network: A at
10.9.0.5, B at 10.9.0.6, and the attacker M at 10.9.0.105. M is a container, so the
scapy code runs inside M. Same weekly code habit: each wrapper asks for the code and
prints it at the end.

### Setup (on the SEED VM)

```
cd ARP_Attack
wget --no-check-certificate https://seedsecuritylabs.org/Labs_20.04/Files/ARP_Attack/Labsetup.zip
unzip Labsetup.zip
cd Labsetup && dcbuild && dcup
```

### Run the tasks

```
cd ARP_Attack
./task1A.sh   # poison B's cache with a spoofed ARP request
./task1B.sh   # poison B's cache with a spoofed ARP reply
./task1C.sh   # poison B's cache with a gratuitous ARP
./task3.sh    # netcat man in the middle, M rewrites what A sends to B
./task2.sh    # telnet man in the middle, then telnet from A and type; ./task2_stop.sh to end
```

Note on Task 1: an ARP request poisons any existing entry, but a reply or gratuitous
message only rewrites an entry that already exists and has gone stale, and neither can
create a missing one. The wrappers set that up for you so the before and after are clear.

Tested on the SEED 20.04 VM.
