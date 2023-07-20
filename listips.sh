#!/bin/bash

machines=$(virsh list --all | grep -v "^ Id" | awk '{print $2}' | xargs -n 1 echo | sort)
for machinename in $machines; do
    # ip=$(virsh domifaddr $machinename | grep "ipv4" | awk '{print $4}')
    ip=$(virsh domifaddr $machinename | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
    
    echo "host-record=$machinename.kubelab,$ip"
done
