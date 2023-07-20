#!/bin/bash
virsh list --all | grep -v "^ Id" | awk '{print $2}' | xargs -n 1 virsh destroy
#virsh list --all --name | xargs -n 1 virsh start

create_seedimage() {
    local machinename="$1"
    local seedinitpath="/500gb/seed-init/$machinename.iso"
    mkdir -p "cloudinit/tmp"
    rm "cloudinit/tmp/$machinename" -rf
    rm "$seedinitpath" -f
    mkdir "cloudinit/tmp/$machinename"

    # create user-data and meta-data files
    cp cloudinit/user-data "cloudinit/tmp/$machinename/user-data"
    cp cloudinit/meta-data "cloudinit/tmp/$machinename/meta-data"

    sed -i "s/<temphostname>/$machinename/g" "cloudinit/tmp/$machinename/meta-data"

    #cloud-localds them both
    cloud-localds "$seedinitpath" "cloudinit/tmp/$machinename/user-data" "cloudinit/tmp/$machinename/meta-data"

    #return path to seedinitpath
    echo "$seedinitpath"
}
create_harddrive() {
    local machinename="$1"
    local disksize="$2"
    local outputfile="$machinename-disk.qcow2"
    local outputpath="/2000gb/$outputfile"
    qemu-img convert -f "qcow2" -O qcow2 /500gb/iso/ubuntu-20.04-server-cloudimg-amd64.img "$outputpath"
    # qemu-img convert -f "qcow2" -O qcow2 /500gb/iso/jammy-server-cloudimg-amd64.img "$outputpath"

    # qemu-img convert -f "qcow2" -O qcow2 /500gb/iso/lunar-server-cloudimg-amd64.img "$outputpath"
    qemu-img resize --preallocation=metadata "$outputpath" "$disksize"
}
create_machine() {
    local machinename="$1"
    local outputfile="$machinename-disk.qcow2"
    local seedinitpath="/500gb/seed-init/$machinename.iso"
    outputpath="/2000gb/$outputfile"

    # --transient \
    virt-install --name "$machinename" --disk "$outputpath",device=disk,bus=virtio --disk "$seedinitpath",device=cdrom \
        --os-variant="ubuntu20.04" \
        --noreboot \
        --autostart \
        --virt-type kvm \
        --vcpus "$2" \
        --memory "$3" \
        --network bridge=kubebr \
        --console pty,target_type=serial \
        --video virtio \
        --import \
        --noautoconsole
    virsh start "$machinename"
    virsh autostart "$machinename"
    echo "Created vm $machinename"
}
# --network network=default,model=virtio \
create_vm() {
    local machinename="$1"
    local diskdize="$4"
    create_seedimage "$machinename"
    create_harddrive "$machinename" "$diskdize"
    create_machine "$machinename" "$2" "$3"
    # ls "/500gb/seed-init/"
}
for i in {1..2}; do
    create_vm "lb-$i" "1" "1024" "10G" &
    echo "done lb-$i"
done
for i in {1..3}; do
    create_vm "master-$i" "4" "2048" "25G" &
    echo "done master-$i"
done
for i in {1..6}; do
    create_vm "worker-$i" "4" "16392" "100G" &
    echo "done worker-$i"
done

# watch sh listips.sh

# virsh list --all | grep -v "^ Id" | awk '{print $2}' | xargs -n 1 virsh destroy"
