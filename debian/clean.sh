#!/bin/bash
set -e

source common/ui.sh
source common/utils.sh

debug 'Bringing container up'
utils.lxc.start

info "Cleaning up '${CONTAINER}'..."

log 'Removing temporary files...'
rm -rf ${ROOTFS}/tmp/*

log 'removing nameserver settings'
echo '' > ${ROOTFS}/etc/resolv.conf

log 'adding script ${ROOTFS}/root/disable_dhcp_client.sh to disable dhcp'
cat <<EOF > ${ROOTFS}/root/disable_dhcp_client.sh
#!/bin/bash
echo -e "auto lo\niface lo inet loopback" > /etc/network/interfaces
EOF
chmod 0700 ${ROOTFS}/root/disable_dhcp_client.sh

log 'cleaning up dhcp leases'
rm -f ${ROOTFS}/var/lib/dhcp/*

log 'Removing downloaded packages...'
utils.lxc.attach apt-get clean
