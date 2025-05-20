#!/usr/bin/env bash

# Get the kubeconfig file from the master node
ssh ubuntu@192.168.20.40 'sudo cat /etc/rancher/k3s/k3s.yaml' > ~/.kube/config
sed -i.bak 's/127.0.0.1/192.168.20.40/g' ~/.kube/config
# scp ubuntu@192.168.20.40:~/k3s.yaml ~/.kube/config