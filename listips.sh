machines=$(virsh list --all | grep -v "^ Id" | awk '{print $2}' | xargs -n 1 echo)
for machinename in $machines; do
    ip=$(virsh domifaddr $machinename | grep "ipv4" | awk '{print $4}')
    echo "$machinename: $ip"
done
