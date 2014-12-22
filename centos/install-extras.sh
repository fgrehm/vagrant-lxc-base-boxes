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

# install the fedora epel repo?
EPEL=${EPEL:-0}

# TODO: Support for appending to this list from outside
PACKAGES=(vim curl wget man ca-certificates sudo openssh-server)

if [ $EPEL = 1 ]; then
  utils.lxc.attach yum update -y
  utils.lxc.attach yum install epel-release -y
  PACKAGES+=' bash-completion'
fi

utils.lxc.attach yum update -y
utils.lxc.attach yum install ${PACKAGES[*]} -y
