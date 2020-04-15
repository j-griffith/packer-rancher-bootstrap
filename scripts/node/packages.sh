#!/bin/bash

PACKAGES="
curl
ntp
sudo
socat
ebtables
apt-transport-https
ca-certificates
gnupg2
jq
prips
software-properties-common
cloud-utils
nfs-common
python3
python3.7-dev
python3-setuptools
open-iscsi
lsscsi
sg3-utils
multipath-tools
scsitools
resolvconf
"
apt update
apt -y install --no-install-recommends $PACKAGES
apt -y install python3-pip
