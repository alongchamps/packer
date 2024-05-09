# packer
Holds files relating to packer build scripts

# Invocation
To build these templates, these are the commands I use:

`cd /ubuntu-2310-kubes`
`packer build -on-error=ask -var-file variables.ubuntu2310.hcl ubuntu2310.pkr.hcl`
