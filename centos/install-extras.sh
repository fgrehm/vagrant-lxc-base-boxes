#!/bin/bash
set -e

source common/ui.sh
source common/utils.sh

info 'Installing extra packages and upgrading'

debug 'Bringing container up'
utils.lxc.start

# Sleep for a bit so that the container can get an IP
log 'Sleeping for 10 seconds...'
sleep 10

utils.lxc.attach yum update -y

# TODO: Support for appending to this list from outside
PACKAGES=(vim curl wget man-db bash-completion python-software-properties ca-certificates sudo nfs-common openssh-server)
utils.lxc.attach yum install ${PACKAGES[*]} -y
