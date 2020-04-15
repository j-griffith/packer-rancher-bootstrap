# Packer files to build rancher bootstrap OVA using vsphere-iso

This builds a simple Ubuntu 18.04 OVA with Rancher Server installed.

It includes an init.d script that will automatically start the Rancher
on boot, which can then be used as a bootstrap cluster to build a
"production" rancher cluster.

## Variables File

Use a variables file to specify vSphere credentials and settings.

EG

"""
{
    "vcenter_server":"10.111.222.77",
    "username":"administrator@vsphere.local",
    "password":"password!",
    "datastore":"Datastore-01",
    "cluster": "Cluster-01",
    "network": "01-VM_Network",
    "ssh_username": "ubuntu",
    "ssh_password": "ubuntu",
    "ssh_key_src_pub": "/Users/jdg/.ssh/id_rsa.pub",
    "image_home_dir": "/home/"
}
"""

## Build It

packer build -var-file=./.variables bootstrap-ova.json
