#!/usr/bin/env bash

# Shutdown the lab

echo "Starting All Nodes"

response=$(curl -s -H "Authorization: PVEAPIToken=${PROXMOX_ID}!${PROXMOX_TOKEN}=${PROXMOX_SECRET}" \
    https://${PROXMOX_URL}/api2/json/cluster/resources?type=vm)


for vmid in $(jq -r '.data[] | select(.name | contains("k8s")) | .vmid' <<< "$response"); do
    node=$(jq -r '.data[] | select(.vmid == '$vmid') | .node' <<< "$response")
    echo "  Starting VM $vmid on node $node"
    start_response=$(curl -s -H "Authorization: PVEAPIToken=${PROXMOX_ID}!${PROXMOX_TOKEN}=${PROXMOX_SECRET}" \
        https://${PROXMOX_URL}/api2/json/nodes/${node}/qemu/${vmid}/status/start -X POST)
done
