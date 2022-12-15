#!/bin/sh
# virt-install \
#     --install ubuntufocal
#     --unattended
#     # --os-variant ubuntufocal \
#     # --location https://cloud-images.ubuntu.com/focal/current/ \
#     --name testare \
#     # --pool pool

# sudo virt-install \
#     --pxe \
#     --name=myvm \
#     --ram=4024 \
#     --vcpus=4 \
#     --disk "path=/2000gb/test.qcow2,size=20" \
#     --osinfo "require=off"

# cp /500gb/iso/focal-server-cloudimg-amd64.img /2000gb/demo2.img
# virt-install \
#     --name=demo1 \
#     --description "Shalalala lala" \
#     --virt-type=kvm \
#     --disk "path=/2000gb/demo2.img,size=20" \
#     --memory=4000 \
#     --vcpu=4 \
#     # --osinfo "require=off" \
#     --os-type linux2020 \
#     --import \
#     --os-variant "ubuntu20.04"

sudo virt-install \
    --name proxy1 \
    --memory 4000 \
    --vcpu 4 \
    --location "http://us.archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/" \
    --disk "/2000gb/proxy1.img,device=disk,bus=virtio,size=20" \
    --os-variant "ubuntu20.04" \
    --virt-type kvm \
    --cloud-init "root-password-file=/home/lollen/passwd,root-ssh-key=/home/lollen/.ssh/id_rsa.pub" \
    --import
