# vCenter specific configurations
variable "vcenter_username" {
  type = string
  description = "Username for vCenter connection."
  nullable = false
}

variable "vcenter_password" {
  type = string
  description = "Password for vCenter connection."
  sensitive = true
  nullable = false
}

variable "vcenter_allow_insecure" {
  type = bool
  description = "If true, does not validate the vCenter's certificate."
  default = true
}

variable "vcenter_server" {
  type = string
  description = "Which vCenter to connect to."
  nullable = false
}

variable "vcenter_datacenter" {
  type = string
  description = "Which datacenter to build the template in"
  nullable = false
}

variable "vcenter_cluster" {
  type = string
  description = "The cluster where the template is built."
  default = ""
}

variable "esxi_host" {
  type = string
  description = "The host on which the vCenter is built."
  nullable = false
}

variable "vcenter_folder" {
  type = string
  description = "The name of the vCenter folder to build in."
  nullable = false
}

variable "vcenter_datastore" {
  type = string
  description = "Which datastore to host the VM/template on."
  default = ""
}

variable "vcenter_network" {
  type = string
  description = "Portgroup name to use."
}

# virtual machine connection details

variable "ssh_username" {
  type = string
  description = "Username for SSH connection to the virtual machine while it's being built."
  sensitive = true
  nullable = false
}

variable "ssh_password" {
  type = string
  description = "Password for SSH connection."
  sensitive = true
  nullable = false
}

# vm/template build specific details
variable "vm_name" {
  type = string
  description = "Name of the VM for use in vCenter"
  nullable = false
}

variable "guest_os_type" {
  type = string
  description = "Guest OS type. See valid values on _insert broadcom link here_"
  nullable = false
}

variable "hw_version" {
  type = number
  description = "VMware hardware version to use for the VM. See compatible vlaues here _insert broadcom link_"
  nullable = false
}

variable "boot_mode" {
  type = string
  description = "Whether to use BIOS or EFI for the virtual machine hardware."
  nullable = false
  validation {
    condition = var.vm_boot_mode == "BIOS" || var.vm_boot_mode == "EFI"
    error_message = "Value must be either BIOS or EFI"
  }
}

# VM CPU/Memory/Disk options
variable "cpu_sockets" {
  type = number
  description = "Number of CPU sockets"
  nullable = false
}

variable "cpu_cores_per_socket" {
  type = number
  description = "Number of CPU cores per socket"
  nullable = false
}

variable "mem_size" {
  type = number
  description = "Memory, in MB"
  nullable = false
}

variable "storge_controller_type" {
  type = list(string)
  description = "Storage controller type, e.g. pvscsi"
  nullable = false
}

variable "disk_size" {
  type = number
  description = "Size of the hard drive, in MB"
  nullable = false
}

variable "thin_provision" {
  type = bool
  description = "Whether to use thin provisioning"
  default = true
  nullable = false
}

variable "vm_network_card" {
  type = string
  description = "The virtual network card type."
  nullable = false
}

variable "vm_boot_wait" {
  type = string
  description = "The time to wait before boot. "
  nullable = false
}

variable "shell_scripts" {
  type = list(string)
  description = "A list of scripts."
  default = []
}

# packer specific details
variable "iso_path" {
  type = string
  description = "The path on the source vSphere datastore for ISO images. Accepts vCenter datastore notation, for example: [synology01] ISO/path-to-my-image.iso"
  nullable = false
}

variable "http_directory" {
  type = string
  description = "Relative directory for folder with user-data and meta-data files."
  default = "http"
}

packer {
  required_version = ">= 1.10.0"
  required_plugins {
    vsphere = {
      source  = "github.com/hashicorp/vsphere"
      version = ">= 1.2.4"
    }
  }
}

source "vsphere-iso" "homelab-ubuntu-2310-server" {

}

build {
    sources = [
        "source.vsphere-iso.homelab-ubuntu-2310-server"
    ]

}
