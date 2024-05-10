# Build an Ubuntu 23.10 template on VMware with Packer
This is a minimal example of using packer to build an Ubuntu 23.10 template on a vCenter 7 homelab. The end result should be a deployable template that's powered off in your vCenter.

Credentials are stored in the file `ubuntu-2310-kubes/variables.credentials.pkrvars.hcl`. I've included an example file named `ubuntu-2310-kubes/variables.credentials.pkrvars.hcl.example`. The `.gitignore` included in this repo will exclude that file on purpose to avoid checking secrets in.

# Supported builds
- [Ubuntu 23.10](/ubuntu-2310-kubes/README.md)
