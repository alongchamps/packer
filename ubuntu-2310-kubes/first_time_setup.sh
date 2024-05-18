#!/bin/bash
rm /etc/ssh/ssh_host*
dpkg-reconfigure openssh-server
