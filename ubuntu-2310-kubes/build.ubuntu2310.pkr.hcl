# vCenter specific configurations
variable "vcenter_server" {
  type = string
  description = "Which vCenter to connect to."
}

variable "vcenter_username" {
  type = string
  description = "Username for vCenter connection."
}

variable "vcenter_password" {
  type = string
  description = "Password for vCenter connection."
  sensitive = true
}

variable "vcenter_allow_insecure" {
  type = bool
  description = "If true, does not validate the vCenter's certificate."
  default = true
}

variable "vcenter_datacenter" {
  type = string
  description = "Which datacenter to build the template in"
}

variable "vcenter_cluster" {
  type = string
  description = "The cluster where the template is built."
  default = ""
}

variable "esxi_host" {
  type = string
  description = "The host on which the vCenter is built."
}

variable "vcenter_folder" {
  type = string
  description = "The name of the vCenter folder to build in."
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
}

variable "ssh_password" {
  type = string
  description = "Password for SSH connection."
  sensitive = true
}

# vm/template build specific details
variable "vm_name" {
  type = string
  description = "Name of the VM for use in vCenter"
}

variable "guest_os_type" {
  type = string
  description = "Guest OS type. See valid values on _insert broadcom link here_"
}

variable "hw_version" {
  type = number
  description = "VMware hardware version to use for the VM. See compatible vlaues here _insert broadcom link_"
}

variable "boot_mode" {
  type = string
  description = "Whether to use BIOS or EFI for the virtual machine hardware."
  validation {
    condition = var.boot_mode == "bios" || var.boot_mode == "efi" || var.boot_mode == "efi-secure"
    error_message = "Value must be either bios, efi, or efi-secure."
  }
}

# VM CPU/Memory/Disk options
variable "total_cpu_cores" {
  type = number
  description = "Number of CPU sockets"
}

variable "cpu_cores_per_socket" {
  type = number
  description = "Number of CPU cores per socket"
}

variable "mem_size" {
  type = number
  description = "Memory, in MB"
}

variable "storage_controller_type" {
  type = list(string)
  description = "Storage controller type, e.g. pvscsi"
}

variable "disk_size" {
  type = number
  description = "Size of the hard drive, in MB"
}

variable "thin_provision" {
  type = bool
  description = "Whether to use thin provisioning"
  default = true
}

variable "network_card" {
  type = string
  description = "The virtual network card type."
}

variable "vm_boot_wait" {
  type = string
  description = "The time to wait before boot. "
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
}

variable "http_directory" {
  type = string
  description = "Relative directory for folder with user-data and meta-data files."
  default = "http"
}

# Begin packer details
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
  # vCenter details
  vcenter_server = var.vcenter_server
  insecure_connection = var.vcenter_allow_insecure
  username = var.vcenter_username
  password = var.vcenter_password

  # vCenter inventory path details
  datacenter = var.vcenter_datacenter
  cluster = var.vcenter_cluster
  host = var.esxi_host
  datastore = var.vcenter_datastore
  folder = var.vcenter_folder
  vm_name = var.vm_name

  # VM hardware config details
  cdrom_type = "sata"
  guest_os_type = var.guest_os_type
  vm_version = var.hw_version
  boot_wait = var.vm_boot_wait

  # compute
  CPUs = var.total_cpu_cores
  cpu_cores = var.cpu_cores_per_socket
  RAM = var.mem_size

  disk_controller_type = var.storage_controller_type
  storage {
    disk_size = var.disk_size
    disk_controller_index = 0
    disk_thin_provisioned = var.thin_provision
  }

  network_adapters {
    network = var.vcenter_network
    network_card = var.network_card
  }

  cd_files = [
        "./${var.http_directory}/meta-data",
        "./${var.http_directory}/user-data"]
  cd_label = "cidata"
  boot_command = [
    "e<down><down><down><end>",
    " autoinstall ds=nocloud;",
    "<F10>"
  ]

  # packer details
  ip_settle_timeout = "5m" # required so that packer detects the right IP address [1]
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_port = 22

  #required because packer doesn't know how to wait for the installation to actually finish first
  ssh_timeout = "45m"
  ssh_handshake_attempts = "100"

  shutdown_command = "echo '${var.ssh_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout = "5m"
  http_directory = var.http_directory
  iso_paths = [var.iso_path]

  # finalization details
  remove_cdrom = true
  convert_to_template = true

}

build {
    sources = [
        "source.vsphere-iso.homelab-ubuntu-2310-server"
    ]
    provisioner "shell" {
      execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
      environment_vars = [
        "BUILD_USERNAME=${var.ssh_username}",
      ]
      scripts = var.shell_scripts
      expect_disconnect = true
    }
}


# [1] When a VM with DHCP reboots in my home lab, my wireless router hands out
# the next IP address even though it would be nice if it realized the request
# was coming from a client that already had a DHCP lease.
