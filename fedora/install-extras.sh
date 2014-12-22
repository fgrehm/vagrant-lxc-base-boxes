#!/bin/bash
set -e

source common/ui.sh
source common/utils.sh

info 'Installing extra packages and upgrading'

debug 'Bringing container up'
utils.lxc.start

# Sleep for a bit so that the container can get an IP
SECS=20
log "Sleeping for $SECS seconds..."
sleep $SECS

# TODO: Support for appending to this list from outside
PACKAGES=(vim curl wget man-db bash-completion ca-certificates sudo openssh-server)

utils.lxc.attach yum update -y
utils.lxc.attach yum install ${PACKAGES[*]} -y
