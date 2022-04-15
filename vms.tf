/**********************************************************
 *
 * Proxmox Home - Infra as Code (IaC)
 * Location: ./vms.tf
 *
 * Details:
 *  - VLAN:       true
 *  - Cloud-init: true
 *  - Image:      Ubuntu 20.04 LTS
 *
 *********************************************************/

resource "proxmox_vm_qemu" "vms" {
  for_each    = var.vms
  name        = each.value.name
  desc        = each.value.name
  vmid        = each.value.vmid
  target_node = each.value.target_node
  os_type     = "cloud-init"
  full_clone  = true
  memory      = each.value.memory
  balloon     = each.value.balloon
  sockets     = "1"
  cores       = each.value.vcpu
  cpu         = "host"
  scsihw      = "virtio-scsi-pci"
  clone       = each.value.pm_template
  agent       = 1
  onboot      = each.value.onboot

  disk {
    size    = each.value.disk_size
    type    = var.pm_storage_type
    storage = var.pm_storage_pool
    discard = "on"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = each.value.vlan_tag
  }

  # Cloud-init
  ciuser     = var.ci_user
  cipassword = var.ci_password
  nameserver = var.pm_dmz_ip_nameserver
  ipconfig0  = "ip=${each.value.ip}/24,gw=${each.value.gw}"
  ssh_user   = var.ci_user
  sshkeys    = var.pm_ssh_pub_key

  provisioner "file" {
    source      = "./scripts/${each.value.script}"
    destination = "/tmp/script.sh"

    connection {
      type = "ssh"
      user = var.ci_user
      # password    = var.ci_password
      # private_key = file("~/.ssh/id_rsa")
      private_key = file(each.value.ssh_key_path)
      host        = each.value.ip
    }
  }

  # Post creation actions
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "bash /tmp/script.sh",
    ]

    connection {
      type = "ssh"
      user = var.ci_user
      # password    = var.ci_password
      # private_key = file("~/.ssh/id_rsa")
      private_key = file(each.value.ssh_key_path)
      host        = each.value.ip
    }
  }
}