terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.0.3:8006/api2/json"
  pm_api_token_id = "terraform-prov@pve!terraform"
  pm_api_token_secret = var.proxmox_api_secret
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "kube-server" {
  count = 3
  name = "kube-server-0${count.index + 1}"
  target_node = var.proxmox_host
  clone = var.template_name
  vmid = "500${count.index + 1}"
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "10G"
    type = "scsi"
    storage = "local-lvm"
    iothread = 1
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }


  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.5.${count.index + 1}/16,gw=192.168.0.1"

  sshkeys = var.ssh_key
}

resource "proxmox_vm_qemu" "kube-agent" {
  count = 5
  name = "kube-agent-0${count.index + 1}"
  target_node = var.proxmox_host
  clone = var.template_name
  vmid = "600${count.index + 1}"
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "10G"
    type = "scsi"
    storage = "local-lvm"
    iothread = 1
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.6.${count.index + 1}/16,gw=192.168.0.1"

  sshkeys = var.ssh_key
}

resource "proxmox_vm_qemu" "kube-storage" {
  count = 1
  name = "kube-storage-0${count.index + 1}"
  target_node = var.proxmox_host
  clone = var.template_name
  vmid = "700${count.index + 1}"
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "100G"
    type = "scsi"
    storage = "local-lvm"
    iothread = 1
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.7.${count.index + 1}/16,gw=192.168.0.1"

  sshkeys = var.ssh_key
}