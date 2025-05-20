#!/usr/bin/env python

import os
import requests
from proxmoxer import ProxmoxAPI

latest_talos_tag = requests.get('https://api.github.com/repos/talos-systems/talos/releases/latest').json()['tag_name']
talos_iso_url = f'https://github.com/siderolabs/talos/releases/download/{latest_talos_tag}/metal-amd64.iso'


secrets = ['PROXMOX_URL', 'PROXMOX_ID', 'PROXMOX_TOKEN', 'PROXMOX_SECRET', 'PROXMOX_STORAGE']

for secret in secrets:
    if secret not in os.environ:
        raise ValueError(f'{secret} environment variable not set')

PROXMOX_URL = os.environ['PROXMOX_URL']
PROXMOX_ID = os.environ['PROXMOX_ID']
PROXMOX_TOKEN = os.environ['PROXMOX_TOKEN']
PROXMOX_SECRET = os.environ['PROXMOX_SECRET']
PROXMOX_STORAGE = os.environ.get('PROXMOX_STORAGE')

proxmox = ProxmoxAPI(
    PROXMOX_URL,
    port=443,
    user=PROXMOX_ID,
    token_name=PROXMOX_TOKEN,
    token_value=PROXMOX_SECRET,
)

nodes = proxmox.nodes.get()

for node in nodes:
    isos = proxmox.nodes(node['node']).storage(PROXMOX_STORAGE).content.get(content="iso")
    for iso in isos:
        if latest_talos_tag in iso['volid']:
            print(f'Talos ISO {latest_talos_tag} already exists on {node["node"]}')
            break
        else:
            proxmox.nodes(node['node']).storage(PROXMOX_STORAGE)("download-url").post(content="iso", filename=f"metal-{latest_talos_tag}-amd64.iso", url=talos_iso_url)
