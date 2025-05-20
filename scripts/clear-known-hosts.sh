#!/usr/bin/env bash

ips=(40 41 42 50 51 52)
for i in "${ips[@]}"; do 
    ssh-keygen -R 192.168.20.$i
    ssh ubuntu@192.168.20.$i hostname
done