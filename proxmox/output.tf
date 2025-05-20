# output "nodes" {
#     value = data.proxmox_virtual_environment_nodes.available_nodes
# }

# output "latest_ubuntu_24_noble_lxc_img" {
#     value = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_lxc_img[0].id
# }

# output "node_count" {
#     value = length(data.proxmox_virtual_environment_nodes.available_nodes.names)
# }

# output "file_id" {
#     value = proxmox_virtual_environment_download_file.talos_latest[*]
# }

# output "versions" {
#     value = data.external.versions.result
# }

# output "machine_config" {
#     value = data.talos_machine_configuration.control_plane_config
# }

# output "kubeconfig" {
#   value = data.talos_cluster_kubeconfig.dev
#   sensitive = true
# }

# output "mysecret" {
#   value = data.vault_kv_secret_v2.test.data
#   sensitive = true
# }