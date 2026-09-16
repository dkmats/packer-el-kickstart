packer {
  required_version = ">= 1.7.0"
  required_plugins {
    vmware = {
      version = "= 2.1.6"
      source  = "github.com/vmware/vmware"
    }
  }
}
