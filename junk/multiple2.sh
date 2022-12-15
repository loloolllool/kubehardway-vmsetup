#!/bin/sh

for i in {1..10}; do
    virt-install --name machine$i --vcpu=8 --install ubuntu20.04 --unattended "user-password-file=/home/lollen/passwd,profile=jeos" --virt-type kvm --video virtio &
done


virt-install --name machine1 --vcpu=4 --install debian11 --unattended "user-password-file=/home/lollen/passwd,admin-password-file=/home/lollen/passwd,user-login=lollen,profile=jeos" --virt-type kvm --video virtio

virt-install --name machine2 --vcpu=8 --install ubuntu20.04 --cdrom "/500gb/iso/ubuntu-20.04.5-desktop-amd64.iso" --unattended "user-password-file=/home/lollen/passwd,profile=jeos" --virt-type kvm --video virtio 
