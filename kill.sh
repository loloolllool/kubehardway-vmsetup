#!/bin/bash
virsh list --all --name | xargs -n 1 virsh undefine
rm /2000gb/* -f
