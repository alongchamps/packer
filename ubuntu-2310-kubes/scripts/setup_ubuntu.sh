#!/usr/bin/bash

echo '> Starting in-guest script setup_ubuntu.sh'

# update all packages
sudo apt update -y
sudo apt clean

echo '> Turning off swap'
sudo swapoff --all

# The below commands will clear out some unique identifiers in the system.

# enable VMware custom scripts (used during deployment)
vmware-toolbox-cmd config set deployPkg enable-custom-scripts true

# echo '> cleaning up SSH thumbprints'
# sudo rm /etc/ssh/ssh_host*
# note: your deployment process needs to run `sudo dpkg-reconfigure openssh-server`
# in order to regenerate the SSH keys. If we didn't clean these up and force regen
# the keys, every VM that deploys from this template would have the same thumbprint.

# TBD - what do I need to do with machine-id?
# clear out machine-id 
# sudo rm /etc/machine-id

echo '> Packer Template build complete - Ubuntu 23.10'
