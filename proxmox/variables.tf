variable "proxmox_url" {
  description = "The URL of the Proxmox API"
}

variable "proxmox_id" {
  description = "The Proxmox user ID"
}

variable "proxmox_token" {
  description = "The Proxmox token"
}

variable "proxmox_secret" {
  description = "The Proxmox secret"
}

variable "proxmox_ssh_password" {
  description = "The Proxmox SSH password"
}

variable "proxmox_shared_datastore" {
  description = "The Proxmox shared datastore"
}

variable "cloud_image_url" {
  description = "The URL of the cloud image"
  default = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

# variable "proxmox_username" {
#   description = "The Proxmox username"
# }

# variable "proxmox_password" {
#   description = "The Proxmox password"
# }