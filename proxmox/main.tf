data "local_file" "ssh_public_key" {
  filename = "./id_rsa.pub"
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.proxmox_shared_datastore
  node_name    = "kpve0"

  source_raw {
    data = <<-EOF
    #cloud-config
    users:
      - default
      - name: ubuntu
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(data.local_file.ssh_public_key.content)}
        sudo: ALL=(ALL) NOPASSWD:ALL
    runcmd:
        - apt update
        - apt install -y qemu-guest-agent net-tools
        - timedatectl set-timezone America/New_York
        - systemctl enable qemu-guest-agent
        - systemctl start qemu-guest-agent
        - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "k8s_masters" {
  count = 3
  name      = "k8s-master-${count.index}"
  node_name = "kpve${count.index}"
  vm_id      = 100 + count.index
  
  agent {
    enabled = true
  }
  stop_on_destroy = true

  cpu {
    cores = 4
    sockets = 1
  }

  memory {
    dedicated = 8192
  }

  initialization {
    dns {
      domain = "obara.dev"
      servers = ["19.168.1.10", "192.168.10.10"]
    }

    ip_config {
      ipv4 {
        # address = "192.168.20.4${count.index}/24"
        address = "dhcp"
        # gateway = "192.168.20.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image[count.index].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  network_device {
    bridge = "vmbr0"
    mac_address = "bc:24:11:57:a1:a${count.index}"
  }

  started = true
}

resource "proxmox_virtual_environment_vm" "k8s_nodes" {
  count = 3
  name      = "k8s-node-${count.index}"
  node_name = "kpve${count.index}"
  vm_id      = 110 + count.index
  
  agent {
    enabled = true
  }
  stop_on_destroy = true

  cpu {
    type = "x86-64-v2"
    cores = 4
    sockets = 1
  }

  memory {
    dedicated = 32768
  }

  initialization {
    dns {
      domain = "obara.dev"
      servers = ["19.168.1.10", "192.168.10.10"]
    }

    ip_config {
      ipv4 {
        # address = "192.168.20.5${count.index}/24"
        address = "dhcp"
        # gateway = "192.168.20.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image[count.index].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }
  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image[count.index].id
    interface    = "virtio1"
    iothread     = true
    discard      = "on"
    size         = 1000
  }

  network_device {
    bridge = "vmbr0"
    mac_address = "bc:24:11:57:a1:b${count.index}"
  }

  started = true
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  count = 3
  content_type = "iso"
  datastore_id = "local"
  node_name    = "kpve${count.index}"
  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}