# EL distros template

source "vmware-iso" "el" {
  http_content = {
    "/ks.cfg" = templatefile(
      "${var.ks.template_path}", {
        major_version = var.el_major_version,
        network       = var.network,
        ks            = var.ks,
    })
  }
  iso_urls                = local.iso_urls[var.distribution]
  iso_checksum            = local.iso_checksum[var.distribution]
  snapshot_name           = var.snapshot_name
  shutdown_command        = var.shutdown_command
  ssh_username            = var.ssh_username
  ssh_host                = var.network.address
  ssh_timeout             = var.ssh_timeout
  temporary_key_pair_type = "ed25519"
  boot_command = [
    "e",
    "<down><down>",
    "<leftCtrlOn>e<leftCtrlOff>",
    "<spacebar>",
    "inst.text",
    "<spacebar>",
    "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg",
    "<spacebar>",
    "inst.repo=${local.inst_repo[var.distribution]}",
    "<spacebar>",
    "PACKER_USER=${var.ssh_username}",
    "<spacebar>",
    "PACKER_AUTHORIZED_KEY={{ .SSHPublicKey | urlquery }}",
    "<leftCtrlOn>x<leftCtrlOff>",
  ]
  boot_wait            = var.boot_wait
  boot_key_interval    = var.boot_key_interval
  disk_size            = var.disk_size
  guest_os_type        = local.guest_os_type[var.arch]
  version              = 22
  vm_name              = local.vm_name
  firmware             = var.firmware
  skip_compaction      = var.skip_compaction
  cpus                 = var.cpus * var.cores
  cores                = var.cores
  memory               = var.memory
  network              = var.network.type
  network_adapter_type = "vmxnet3"
  headless             = var.headless
  output_directory     = var.output_directory
  disk_adapter_type    = var.disk_adapter_type
  disk_type_id         = var.disk_type_id
}

build {
  sources = [
    "source.vmware-iso.el",
  ]

  provisioner "shell" {
    inline = [
      "sudo dnf install -y open-vm-tools",
      "sudo rm -fr /tmp/*",
      "sudo rm -fr /var/tmp/*",
    ]
  }
}
