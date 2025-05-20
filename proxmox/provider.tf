terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.61.1"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
  backend "s3" {
    bucket                      = "k8s-terraform"
    key                         = "terraform.tfstate"
    region                      = "main"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }
}

provider "proxmox" {
  endpoint = "https://${var.proxmox_url}"
  api_token = "${var.proxmox_id}!${var.proxmox_token}=${var.proxmox_secret}"
  ssh {
    node {
      name = "kpve0"
      address = "192.168.20.20"
    }
    node {
      name = "kpve1"
      address = "192.168.20.21"
    }
    node {
      name = "kpve2"
      address = "192.168.20.22"
    }
    agent = true
    username = "root"
    password = var.proxmox_ssh_password
  }
}
