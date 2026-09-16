# Mandatory settings
arch             = "x86_64"
distribution     = "almalinux"
el_major_version = 10
ks_template_path = "ks.cfg.tftpl"

# Mandatory for Oracle Linux
# oracle_minor_version = 0

# Common VM settings
vm_name           = "test"
cpus              = 1
cores             = 2
memory            = 4 * 1024
disk_size         = 20 * 1024
boot_key_interval = "10ms"
boot_wait         = "3s"
output_directory  = "output"

# To enable secure boot
# firmware = "efi-secure"

# Kickstart settings
ks = {
  # lang               = "en_US.UTF-8"
  # vckeymap           = "jp-OADG109A"
  # xlayouts           = "jp(OADG109A)"
  # timezone           = "Asia/Tokyo"
  # ntpservers         = [
  #  "ntp1.jst.mfeed.ad.jp",
  #  "ntp2.jst.mfeed.ad.jp",
  #  "ntp3.jst.mfeed.ad.jp",
  # ]

  # User settings
  user = {
    # name     = "test"
    # password = "testpass"

    # Set your SSH public key
    ssh_pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBFbe3PGauS2HyArZnTOVLxuQVVoEmG8lDc57Ggl+yA matsuyama_daiki@2022-09-07"
  }
}

# Network settings
# Leave the settings below uncommented for default DHCP behaviour
# network = {
#   type       = "bridged"
#   address    = "192.168.x.x"
#   mask       = "255.255.0.0"
#   gateway    = "192.168.0.1"
#   nameserver = "192.168.0.1"
# }

# To preallocate disk space instead of using a sparse file
# disk_type_id    = "2"
# skip_compaction = true
