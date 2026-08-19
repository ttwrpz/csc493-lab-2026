#!/bin/bash
# Task 1.3 -- traceroute to a destination (Linux traceroute command).
read -p "Enter weekly code (e.g. WK01-ASDK): " WK
traceroute 8.8.8.8
echo "$WK"
