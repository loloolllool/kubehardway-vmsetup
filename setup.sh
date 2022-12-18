#!/bin/bash
#virsh list --all | grep -v "^ Id" | awk '{print $2}' | xargs -n 1 virsh destroy

#seedinitpath="/500gb/iso/seed-init.iso"
#rm seedinitpath -f
cloud-localds $seedinitpath cloudinit/user-data cloudinit/meta-data
create_seedimage() {
    machinename="$1"
    mkdir -p "cloudinit/tmp"
    rm "cloudinit/tmp/$machinename" -rf
    mkdir "cloudinit/tmp/$machinename"
    cp cloudinit/user-data "cloudinit/tmp/$machinename/user-data"
    cp cloudinit/meta-data "cloudinit/tmp/$machinename/meta-data"
    # create user-data and meta-data files
    sed -i "s/etthostname/$machinename/g" "cloudinit/tmp/$machinename/meta-data"
    #cloud-localds them both

    #return path to seedinitpath
}
create_harddrive() {
    echo "creating harddrive2"
    machinename="$1"
    outputfile=$machinename-disk.qcow2
    outputpath=/2000gb/$outputfile
    qemu-img convert -f "qcow2" -O qcow2 /500gb/iso/lunar-server-cloudimg-amd64.img "$outputpath"
    qemu-img resize --preallocation=metadata "$outputpath" 25G
    echo "Done with: $machinename"
}
create_machine() {
    echo "creating vm"
    machinename="$1"
    outputfile=$machinename-disk.qcow2
    outputpath=/2000gb/$outputfile

    virt-install --name "$machinename" --disk "$outputpath",device=disk,bus=virtio --disk "$seedinitpath",device=cdrom \
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

create_vm() {
    machinename=$1
    echo "Creating harddrive for $machinename"
    echo "Creating vm for $machinename"
    create_seedimage "$machinename"
    #create_harddrive "$machinename"
    #create_machine "$machinename"
}
for i in {0..4}; do
    create_vm "vmtest-$i" &
done
errorCode=$?
if [ $errorCode -ne 0 ]; then
    echo "We have an error"
    # We exit the all script with the same error, if you don't want to
    # exit it and continue, just delete this line.
    exit $errorCode
fi
# sleep 3
# clear
# watch sh listips.sh
echo "Press any key to continue"
# virsh list --all | grep -v "^ Id" | awk '{print $2}' | xargs -n 1 virsh destroy
