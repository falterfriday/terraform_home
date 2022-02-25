/**********************************************************
 *
 * Proxmox Home - Infra as Code (IaC)
 * Location: ./dmz.tf
 *
 * Details:
 *  - VLAN:       5 (dmzLan)
 *  - Image:      Ubuntu 20.04 LTS
 *  - Cloud-init: true
 *
 *********************************************************/


resource "proxmox_vm_qemu" "vpn01" {
  name        = var.pm_dmz_vpn01_name
  target_node = var.pm_node
  clone       = var.pm_template
  os_type     = "cloud-init"
  cores       = 4
  sockets     = 1
  cpu         = "host"
  memory      = 2048
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  agent       = 1

  disk {
    size     = "20G"
    type     = "scsi"
    storage  = var.pm_storage_pool
    iothread = 0
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 5
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ciuser     = var.ci_user
  cipassword = var.ci_password
  nameserver = var.pm_dmz_ip_nameserver
  ipconfig0  = "ip=${var.pm_dmz_ip_vm_vpn01}/24,gw=${var.pm_dmz_ip_gw}"
  sshkeys    = <<EOF
${var.pm_ssh_personal_pub_key}
EOF
}

output "dmz_ip" {
  value = proxmox_vm_qemu.vpn01.default_ipv4_address
}