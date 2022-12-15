#!/bin/sh

virt-install --name ubuntu-22.04 \
    --transient \
    --memory 2048 \
    --vcpus 2 \
    --disk size=10 \
    --import \
    --virt-type kvm \
    --video virtio \
    --os-variant ubuntu20.04 \
    --cloud-init="network-config=/home/lollen/projects/virtlabs/cloudinit.yaml"