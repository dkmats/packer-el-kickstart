packer {
  required_version = "= 1.16.1" # renovate: datasource=github-releases depName=hashicorp/packer
  required_plugins {
    vmware = {
      version = "= 2.1.6" # renovate: datasource=github-releases depName=vmware/packer-plugin-vmware
      source  = "github.com/vmware/vmware"
    }
  }
}
