#!/usr/bin/env bash
cpu=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2- | sed 's/^ //')
ram_used=$(free -m | awk '/Mem:/ {print $3}')
ram_total=$(free -m | awk '/Mem:/ {print $2}')
load=$(cut -d' ' -f1 /proc/loadavg)
net=$(cat /proc/net/dev | awk '/^e/ {rx+=$2; tx+=$10} END {printf "RX:%0.1f TX:%0.1f", rx/1024/1024, tx/1024/1024}')
printf "%s | RAM:%s/%sM | Load:%s | %s" "$cpu" "$ram_used" "$ram_total" "$load" "$net"
