#!/usr/bin/env bash

ssh ubuntu@192.168.20.40 'sudo hostnamectl set-hostname k3s-master-0 && sudo reboot'
ssh ubuntu@192.168.20.41 'sudo hostnamectl set-hostname k3s-master-1 && sudo reboot'
ssh ubuntu@192.168.20.42 'sudo hostnamectl set-hostname k3s-master-2 && sudo reboot'

ssh ubuntu@192.168.20.50 'sudo hostnamectl set-hostname k3s-worker-0 && sudo reboot'
ssh ubuntu@192.168.20.51 'sudo hostnamectl set-hostname k3s-worker-1 && sudo reboot'
ssh ubuntu@192.168.20.52 'sudo hostnamectl set-hostname k3s-worker-2 && sudo reboot'