#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

WAIT_FOR_DISK=false
CD=""
HDD="winxp.img"
EXTRAARGS=""
RAM="512"
NIC="rtl8139"
while getopts "wd:c:e:r:n:" opt; do
  case $opt in
    w) WAIT_FOR_DISK=true   ;;
    c) CD=$OPTARG   ;;
    d) HDD=$OPTARG   ;;
    e) EXTRAARGS=$OPTARG   ;;
    r) RAM=$RAM   ;;
    rn) NIC=$NIC   ;;
    *) echo 'error' >&2
       exit 1
  esac
done

if [[ "$WAIT_FOR_DISK" == "true" ]]; then
    HAS_DISK="false"
    while [[ "$HAS_DISK" == "false" ]]; do
        if [ ! -f "$HDD" ]; then
            echo "waiting on HDD"
            sleep 1
        else
            if lsof | grep -q "$HDD"; then
                echo "HDD in use by other process"
                sleep 1
            else
                HAS_DISK="true"
            fi
        fi
    done
fi


if [ ! -f $HDD ]; then
    qemu-img create $HDD 10G
fi


if [[ "$CD" != "" ]]; then
    EXTRAARGS+="-drive file=$CD,media=cdrom"
fi

qemu-system-i386 \
    -m $RAM \
    -vga std \
    -soundhw ac97 \
    -net nic,model=$NIC \
    -net user,hostfwd=tcp::3389-:3389 \
    -drive file=$HDD,format=raw \
    $EXTRAARGS
    # the following options require higher privileges 
    # -enable-kvm \
    # -cpu host \
    # -usb \
    # -usbdevice \

