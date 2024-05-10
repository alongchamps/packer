# packer
This is a minimal example of using packer to build an Ubuntu 23.10 template on a vCenter 7 homelab. The end result should be a deployable template that's powered off in your vCenter.

# Invocation
To build these templates, these are the commands I use:

`cd /ubuntu-2310-kubes`

`packer validate -var-file variables.ubuntu2310.pkrvars.hcl -var-file variables.credentials.pkrvars.hcl build.ubuntu2310.pkr.hcl`

`packer build -on-error=ask -var-file variables.ubuntu2310.pkrvars.hcl -var-file variables.credentials.pkrvars.hcl build.ubuntu2310.pkr.hcl`

Credentials are stored in the file `ubuntu-2310-kubes/variables.credentials.pkrvars.hcl`. I've included an example file named `ubuntu-2310-kubes/variables.credentials.pkrvars.hcl.example`. The `.gitignore` included in this repo will exclude that file on purpose to avoid checking secrets in.
