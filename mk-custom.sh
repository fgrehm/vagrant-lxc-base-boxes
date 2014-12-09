#!/bin/bash

# Declare parameters
NAME=$1

# Stop the lxc container if running
lxc-stop -n $NAME

# Remove the previous working dir if existing
if [ -d custom/$NAME ]; then
	rm custom/$NAME -rf
fi

# Creat working dir
mkdir custom/$NAME

# Create tar file of lxc container
cd /var/lib/lxc/boekentoren-puppet-development/
tar --numeric-owner --anchored --exclude=./rootfs/dev/log -czf rootfs.tar.gz ./rootfs/*
chown jan: rootfs.tar.gz
mv rootfs.tar.gz /home/Jan/Projecten/Github.com/vagrant-lxc-base-boxes/custom/$NAME

# Build working dir structure
cd /home/Jan/Projecten/Github.com/vagrant-lxc-base-boxes/custom/$NAME
cp ../../conf/centos lxc-config
cp ../../conf/metadata.json .
sed -i "s/<TODAY>/${NOW}/" metadata.json

# Create actual vagrant box file
tar -czf $NAME.box ./*
cd ../../
ls custom/$NAME/$NAME.box
