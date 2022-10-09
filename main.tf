terraform {
  required_version = ">= 1.2.1"
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">= 2.9.11"
    }
  }
}

# ToDo: move from user/pass to token
provider "proxmox" {
  pm_api_url = var.pm_api_url
  pm_user = var.pm_user
  pm_password = var.pm_password
}

locals {
  serverconfig = [
    for srv in var.configuration : [
      for i in range(1, srv.node_count+1) : {
        vmid        = "${srv.vmid + i}"
        ipaddr      = "${var.ipaddr_network}.${srv.ipaddr_id + i}" 
        name        = "k3s-${srv.k3s_role}-${srv.vmid + i}"
        target_node = "pve${i}"
        sockets    = srv.sockets
        cores      = srv.cores
        memory     = srv.memory
        disks      = srv.disks
      }
    ]
  ]
}

locals {
  instances = flatten(local.serverconfig)
}

resource "proxmox_vm_qemu" "k3s" {
  for_each = {for server in local.instances: server.name =>  server}
  vmid = each.value.vmid
  name = each.value.name
  desc = "## ${each.value.name} running on ubuntu-server-20.04-lts"

  ciuser       = var.ciuser
  cipassword   = var.cipassword
  // cicustom     = "vendor=nfs:snippets/k3s-config.yaml"
  sshkeys      = file(var.sshkeys)
  searchdomain = var.searchdomain
  nameserver   = var.nameserver
  // ipconfig0    = "ip=${var.ipaddr},gw=${var.gateway}"
  ipconfig0    = "ip=${each.value.ipaddr}/${var.cidr},gw=${var.gateway}"

  // target_node = "pve1"
  target_node = each.value.target_node
  clone      = "ubuntu-server-20.04-lts"
  full_clone = true
  os_type    = "ubuntu"
  sockets    = each.value.sockets
  cores      = each.value.cores
  memory     = each.value.memory
  scsihw     = "virtio-scsi-pci"
  boot       = "c"
  bootdisk   = "scsi0"
  vga {
      type = "serial0"
  }
  dynamic "disk"{
    for_each = each.value.disks
    content {
      size    = disk.value.size
      type    = disk.value.type
      storage = disk.value.storage
    }
  }
  network {
      model  = "virtio"
      bridge = "vmbr0"
  }

  // Post-creation
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key)
    host        = "${each.value.ipaddr}"
  }
  provisioner "remote-exec" {
    inline = [ "ip a" ]
    // inline = [ "sudo apt update > /dev/null", "sudo apt install jq open-iscsi nfs-common -y > /dev/null", "sudo apt autoremove > /dev/null", "echo Done!" ]
  }

}

/* 
Reference links used to create this configuration
https://www.middlewareinventory.com/blog/terraform-create-multiple-ec2-different-config/
https://www.middlewareinventory.com/blog/terraform-ebs_block_device-example/
*/