# Ubuntu 23.10 for Kubernetes
This directory holds files for building an Ubuntu 23.10 template.

# Files
`build.ubuntu2310.pkr.hcl` - this file contains the variables needed by packer and the packer build script to make the template.

`variables.credentials.pkrvars.hcl` - this file holds the password for the vCenter user and SSH user on the template.

`variables.ubuntu2310.pkrvars.hcl` - this file contains the variable definitions and values required for this build process. You'll want to adjust unique variables for your own environment, including vCenter details, cluster name, template name, etc.
