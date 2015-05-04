#!/bin/bash

source common/ui.sh

# Declare parameters
export DISTRIBUTION='custom'
export RELEASE='box'
export NAME=$1
export LOCALUSER=$2
export ROOTFS="/var/lib/lxc/${NAME}"
export CURRENT_DIR=`pwd`
export WORKING_DIR=$CURRENT_DIR"/output/${NAME}"
export NOW=$(date -u)
export LOG=$(readlink -f .)/log/${NAME}.log

mkdir -p $(dirname $LOG)
echo '############################################' > ${LOG}
echo "# Beginning build at $(date)" >> ${LOG}
touch ${LOG}
chmod +rw ${LOG}

log "Stopping the running container"

lxc-stop -n $NAME

# Remove the previous working dir if existing
if [ -d $WORKING_DIR ]; then
	warn "Removing existing working dir"
	rm $WORKING_DIR -rf
fi

log "Create working dir"
mkdir $WORKING_DIR

log "Create tar file of lxc container"
cd $ROOTFS
tar --numeric-owner --anchored --exclude=./rootfs/dev/log -czf rootfs.tar.gz ./rootfs/*
chown $LOCALUSER: rootfs.tar.gz
mv rootfs.tar.gz $WORKING_DIR

log "Build working dir structure"
cd $WORKING_DIR
cp ../../conf/centos lxc-config
cp ../../conf/metadata.json .
sed -i "s/<TODAY>/${NOW}/" metadata.json


log "Create actual vagrant box"
tar -czf $NAME.box ./*
cd ../../
ls $WORKING_DIR/$NAME.box
