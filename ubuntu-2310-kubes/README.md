# File list

`build.ubuntu2310.pkr.hcl` - this file contains the variables needed by packer and the packer build script to make the template.

`variables.credentials.pkrvars.hcl` - this file holds the password for the vCenter user and SSH user on the template.

`variables.ubuntu2310.pkrvars.hcl` - this file contains the variable definitions and values required for this build process. You'll want to adjust unique variables for your own environment, including vCenter details, cluster name, template name, etc.

# Invocation
To build these templates, these are the commands I use:

`cd /ubuntu-2310-kubes`

`packer validate -var-file variables.ubuntu2310.pkrvars.hcl -var-file variables.credentials.pkrvars.hcl build.ubuntu2310.pkr.hcl`

`packer build -on-error=ask -var-file variables.ubuntu2310.pkrvars.hcl -var-file variables.credentials.pkrvars.hcl build.ubuntu2310.pkr.hcl`

# Other supporting scripts
`ubuntu-2310-kubes/http/user-data` - This file is the cloud-init build script that's passed in to the VM during the build process. Ubuntu picks this up and applies it to the system.

`ubuntu-2310-kubes/scripts/setup_ubuntu.sh` - This script will run in the guest after the installation has finished. This prepares the VM for the template process.
