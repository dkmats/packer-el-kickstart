packer {
  required_version = "= 1.16.3" # renovate: datasource=github-releases depName=hashicorp/packer
  required_plugins {
    vmware = {
      version = "= 2.1.7" # renovate: datasource=github-releases depName=vmware/packer-plugin-vmware
      source  = "github.com/vmware/vmware"
    }
  }
}
