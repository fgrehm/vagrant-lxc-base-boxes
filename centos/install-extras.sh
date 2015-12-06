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

# Disabling iptables modules reloading
utils.lxc.attach sed -i 's/IPTABLES_MODULES_UNLOAD=\"yes\"/IPTABLES_MODULES_UNLOAD=\"no\"/g' /etc/sysconfig/iptables-config

# Puppet provisioner
PUPPET=${PUPPET:=0}

if [ $PUPPET = 1 ]; then
  if $(lxc-attach -n ${CONTAINER} -- which puppet &>/dev/null); then
    log "Puppet has been installed on container, skipping"
  else
    log "Installing Puppet"
    wget http://yum.puppetlabs.com/puppetlabs-release-el-${RELEASE}.noarch.rpm -O "${ROOTFS}/tmp/puppetlabs-release-stable.rpm" &>>${LOG}
    utils.lxc.attach rpm -Uvh "/tmp/puppetlabs-release-stable.rpm"
    utils.lxc.attach yum update -y
    utils.lxc.attach yum install puppet -y
  fi
fi
