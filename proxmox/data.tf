data "proxmox_virtual_environment_nodes" "available_nodes" {}

data "proxmox_virtual_environment_datastores" "nodes" {
    for_each = {for idx, val in data.proxmox_virtual_environment_nodes.available_nodes.names: idx => val}
    node_name = each.value
}
