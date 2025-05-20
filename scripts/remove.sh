#!/usr/bin/env bash

# Shutdown the lab

echo "Removing All Nodes"

response=$(curl -s -H "Authorization: PVEAPIToken=${PROXMOX_ID}!${PROXMOX_TOKEN}=${PROXMOX_SECRET}" \
    https://${PROXMOX_URL}/api2/json/cluster/resources?type=vm)


for vmid in $(jq -r '.data[] | select(.name | contains("k8s")) | .vmid' <<< "$response"); do
    # echo "Stopping VM $vmid"
    # if [[ "$vmid" -gt 199 ]]; then
    node=$(jq -r '.data[] | select(.vmid == '$vmid') | .node' <<< "$response")
    echo "  Stopping VM $vmid on node $node"
    curl -s -H "Authorization: PVEAPIToken=${PROXMOX_ID}!${PROXMOX_TOKEN}=${PROXMOX_SECRET}" \
        https://${PROXMOX_URL}/api2/json/nodes/${node}/qemu/${vmid}/status/stop -X POST
    curl -s -H "Authorization: PVEAPIToken=${PROXMOX_ID}!${PROXMOX_TOKEN}=${PROXMOX_SECRET}" \
        https://${PROXMOX_URL}/api2/json/nodes/${node}/qemu/${vmid} -X DELETE
    # fi
done
