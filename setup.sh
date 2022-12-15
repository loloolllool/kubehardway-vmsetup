#!/bin/bash
virsh list --all | grep -v "^ Id" | awk '{print $2}' | xargs -n 1 virsh destroy

seedinitpath="/500gb/iso/seed-init.iso"
rm seedinitpath -f
cloud-localds $seedinitpath cloudinit/user-data cloudinit/meta-data

create_harddrive() {
    i=$1
    machinename="machine$i"
    outputfile=$machinename-disk.qcow2
    outputpath=/2000gb/$outputfile
    qemu-img convert -f "qcow2" -O qcow2 /500gb/iso/lunar-server-cloudimg-amd64.img $outputpath
    qemu-img resize --preallocation=metadata $outputpath 25G
    echo "Done with: $machinename"
}


create_machine() {
    i=$1
    machinename="machine$i"
    outputfile=$machinename-disk.qcow2
    outputpath=/2000gb/$outputfile

    virt-install --name $machinename --disk "$outputpath",device=disk,bus=virtio --disk "$seedinitpath",device=cdrom \
        --os-variant="ubuntu20.04" \
        --transient \
        --virt-type kvm \
        --vcpus "4" \
        --memory "4048" \
        --network network=default,model=virtio \
        --console pty,target_type=serial \
        --video virtio \
        --import \
        --noautoconsole 
}

echo "Creating harddrives"
for i in {0..1}; do
    create_harddrive $i &
done
wait
for i in {0..1}; do
    create_machine $i &
done
# sleep 3
# clear
# watch sh listips.sh
echo "Press any key to continue"
# virsh list --all | grep -v "^ Id" | awk '{print $2}' | xargs -n 1 virsh destroy