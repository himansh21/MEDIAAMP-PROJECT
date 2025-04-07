terraform {
  required_version = ">= 1.3.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://192.168.0.11:8006/api2/json"
  pm_user         = "proxmox_username"
  pm_password     = "Proxmox_password"
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "ubuntu_vm" {
  name        = "ubuntu-22.04"
  target_node = "proxmox"
  clone       = "ubuntu-22.04-template"
  full_clone  = true
  scsihw      = "virtio-scsi-single"
  cores       = 2
  sockets     = 1
  cpu_type    = "qemu64"
  memory      = 2048
  os_type     = "cloud-init"
  agent       = 1
  kvm         = false
  machine     = "q35"

  network {
    id     = 0
    model  = "e1000"
    bridge = "vmbr1"
  }

  disk {
    slot     = "scsi0"
    type     = "disk"
    storage  = "local-lvm"
    size     = "20G"
    iothread = true
  }

  ipconfig0  = "ip=10.0.0.100/24,gw=192.168.0.1"
  ciuser     = "username"
  cipassword = "password"
  sshkeys    = file("~/.ssh/id_rsa.pub")

  serial {
    id   = 0
    type = "socket"
  }

  vga {
    type = "serial0"
  }
}

# ----------------------
# Ubuntu 22.04 LXC
# ----------------------
resource "proxmox_lxc" "ubuntu_container" {
  hostname    = "ubuntu-lxc"
  vmid        = 100
  target_node = "proxmox"
  ostemplate  = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  password    = "root123"

  cores        = 1
  memory       = 512
  swap         = 0
  unprivileged = true

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr1"
    ip     = "10.0.0.101/24"
    gw     = "10.0.0.1"
  }

  features {
    nesting = true
  }

  start = true
}
