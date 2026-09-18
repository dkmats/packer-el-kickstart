variable "arch" {
  description = "CPU architecture"
  type        = string

  validation {
    condition     = contains(["x86_64", "aarch64"], var.arch)
    error_message = "The variable `arch` must be \"x86_64\" or \"aarch64\"."
  }
}

variable "distribution" {
  description = "EL distribution name"
  type        = string

  validation {
    condition     = contains(["almalinux", "rocky", "oracle", "oracle-uek"], var.distribution)
    error_message = "The variable `distribution` must be \"almalinux\" or \"rocky\"."
  }
}

variable "el_major_version" {
  description = "EL major version"
  type        = number

  validation {
    condition = (
      var.el_major_version >= 8 &&
      var.el_major_version == floor(var.el_major_version)
    )
    error_message = "The variable `el_major_version` must be an integer greater than or equal to 8."
  }
}

variable "oracle_minor_version" {
  description = "Oracle Linux minor version"
  type        = number
  default     = null

  validation {
    condition = (
      var.oracle_minor_version == null ||
      (
        var.oracle_minor_version <= 10 &&
        var.oracle_minor_version == floor(var.oracle_minor_version)
      )
    )
    error_message = "The variable `oracle_minor_version` must be null or an integer less than or equal to 10."
  }
}

# Common

variable "vm_name" {
  description = "The VM name"

  type    = string
  default = "test"
}

variable "headless" {
  description = "Disable GUI"

  type    = bool
  default = false
}

variable "boot_wait" {
  description = "Time to wait before typing boot command"

  type    = string
  default = "10s"
}

variable "boot_key_interval" {
  description = "The interval between each keystrokes."

  type    = string
  default = "25ms"
}

variable "cpus" {
  description = "The number of virtual cpu sockets"

  type    = number
  default = 1
}

variable "cores" {
  description = "The number of virtual cpu cores per socket"

  type    = number
  default = 2
}

variable "memory" {
  description = "The amount of memory to use when building the VM in megabytes"

  type    = number
  default = 4096
}

variable "disk_size" {
  description = "The amount of disk to use when building the VM in megabytes"

  type    = number
  default = 20480
}


variable "ssh_timeout" {
  description = "The time to wait for SSH to become available"

  type    = string
  default = "3600s"
}

variable "ssh_username" {
  description = "The username of the user used while building the image."

  type    = string
  default = "packer"
}

variable "skip_compaction" {
  description = "Skip compaction after building"

  type    = bool
  default = false
}

variable "disk_type_id" {
  description = "The type of virtual disk to create."

  type    = string
  default = "1"
  validation {
    condition     = contains(["0", "1", "2", "3", "4", "5"], var.disk_type_id)
    error_message = "The value must be within 0 to 5."
  }
}

variable "output_directory" {
  description = "The path of the directory where the resulting virtual machine will be created."

  type    = string
  default = "output"
}

variable "firmware" {
  description = "The firmware type for the virtual machine."

  type    = string
  default = "efi"
  validation {
    condition     = contains(["bios", "efi", "efi-secure"], var.firmware)
    error_message = "The firmware type must be \"bios\", \"efi\" or \"efi-secure\"."
  }
}

variable "disk_adapter_type" {
  description = "The adapter type for additional virtual disk(s)."

  type    = string
  default = "nvme"
  validation {
    condition     = contains(["ide", "sata", "nvme", "scsi"], var.disk_adapter_type)
    error_message = "The disk_adapter_type must be \"ide\", \"sata\", \"nvme\" or \"scsi\"."
  }
}

variable "shutdown_command" {
  description = "The command to use to gracefully shut down the machine once all provisioning is complete."

  type    = string
  default = "sudo shutdown -hP now"
}

variable "snapshot_name" {
  description = "The name of the virtual machine snapshot to be created."

  type    = string
  default = "Kickstart installation completed"
}

variable "network" {
  description = "NIC configuration"
  type = object({
    type       = optional(string, "nat")
    address    = optional(string)
    mask       = optional(string)
    gateway    = optional(string)
    nameserver = optional(string)
  })

  default = {}

  validation {
    condition = contains(
      ["nat", "bridged", "hostonly"],
      var.network.type
    )

    error_message = "The variable `network.type` must be \"nat\", \"bridged\" or \"hostonly\"."
  }

  validation {
    condition = (
      var.network.address == null ||
      (
        can(cidrhost("${var.network.address}/32", 0)) &&
        var.network.mask != null &&
        var.network.gateway != null &&
        var.network.nameserver != null
      )
    )

    error_message = "When `network.type` is \"bridged\", `network.address`, `network.mask` and `network.gateway` must be specified."
  }
}

variable "ks" {
  type = object({
    template_path = string
    lang          = optional(string, "en_US.UTF-8")
    vckeymap      = optional(string, "jp-OADG109A")
    xlayouts      = optional(string, "jp(OADG109A)")
    timezone      = optional(string, "Asia/Tokyo")
    root_password = optional(string, "rootpass")
    ntpservers = optional(list(string), [
      "ntp1.jst.mfeed.ad.jp",
      "ntp2.jst.mfeed.ad.jp",
      "ntp3.jst.mfeed.ad.jp",
    ])
    authselect_profile = optional(string, null)
    packer_username    = optional(string, "packer")
    user = object({
      name       = optional(string, "test")
      password   = optional(string, "testpass")
      ssh_pubkey = string
    })
  })
}

locals {
  inst_repo = {
    almalinux  = "https://ftp.udx.icscoe.jp/Linux/almalinux/${var.el_major_version}/BaseOS/${var.arch}/kickstart/"
    rocky      = "https://ftp.udx.icscoe.jp/Linux/rocky/${var.el_major_version}/BaseOS/${var.arch}/kickstart/"
    oracle     = "https://yum.oracle.com/repo/OracleLinux/OL${var.el_major_version}/baseos/latest/${var.arch}/"
    oracle-uek = "https://yum.oracle.com/repo/OracleLinux/OL${var.el_major_version}/baseos/latest/${var.arch}/"
  }

  iso_urls = {
    almalinux = [
      "https://ftp.udx.icscoe.jp/Linux/almalinux/${var.el_major_version}/isos/${var.arch}/AlmaLinux-${var.el_major_version}-latest-${var.arch}-boot.iso",
      "https://repo.almalinux.org/almalinux/${var.el_major_version}/isos/${var.arch}/AlmaLinux-${var.el_major_version}-latest-${var.arch}-boot.iso",
    ]
    rocky = [
      "https://ftp.udx.icscoe.jp/Linux/rocky/${var.el_major_version}/isos/${var.arch}/Rocky-${var.el_major_version}-latest-${var.arch}-boot.iso",
      "https://download.rockylinux.org/pub/rocky/${var.el_major_version}/isos/${var.arch}/Rocky-${var.el_major_version}-latest-${var.arch}-boot.iso",
    ]
    oracle = var.oracle_minor_version != null ? [
      "https://yum.oracle.com/ISOS/OracleLinux/OL${var.el_major_version}/u${var.oracle_minor_version}/${var.arch}/OracleLinux-R${var.el_major_version}-U${var.oracle_minor_version}-${var.arch}-boot.iso"
    ] : null
    oracle-uek = var.oracle_minor_version != null ? [
      "https://yum.oracle.com/ISOS/OracleLinux/OL${var.el_major_version}/u${var.oracle_minor_version}/${var.arch}/OracleLinux-R${var.el_major_version}-U${var.oracle_minor_version}-${var.arch}-boot-uek.iso"
    ] : null
  }

  iso_checksum = {
    almalinux  = "file:https://repo.almalinux.org/almalinux/${var.el_major_version}/isos/${var.arch}/CHECKSUM"
    rocky      = "file:https://download.rockylinux.org/pub/rocky/${var.el_major_version}/isos/${var.arch}/CHECKSUM"
    oracle     = var.oracle_minor_version != null ? "file:https://linux.oracle.com/security/gpg/checksum/OracleLinux-R${var.el_major_version}-U${var.oracle_minor_version}-Server-${var.arch}.checksum" : null
    oracle-uek = var.oracle_minor_version != null ? "file:https://linux.oracle.com/security/gpg/checksum/OracleLinux-R${var.el_major_version}-U${var.oracle_minor_version}-Server-${var.arch}.checksum" : null
  }

  guest_os_type = {
    x86_64 = (
      var.el_major_version == 8
      ? "centos8-64"
      : "rhel${var.el_major_version}-64"
    )

    aarch64 = (
      var.el_major_version == 8
      ? "centos8-64"
      : "arm-rhel${var.el_major_version}-64"
    )
  }

  vm_name = "${var.distribution}${var.el_major_version}-${var.vm_name}"
}
