#!/bin/bash

echo "Try to find all empty USB partitions"
IFS=$'\n'
for MOUNT in `df | sed "s/^ *//;s/ *$//;s/ \{1,\}/ /g" | cut --delimiter=" " -f6- | grep "/media/"`
do
    if [ "$(ls -A "$MOUNT")" = "" ]
    then
	DEVICE=`df | sed "s/^ *//;s/ *$//;s/ \{1,\}/ /g" | grep "$MOUNT$" | cut --delimiter=" " -f1`
	echo "Dumping master to $DEVICE..."
	sudo dd if=usb.dd of=$DEVICE bs=1M
	sync
	umount $MOUNT
    else
	echo "$MOUNT is not empty, nothing was dumped here."
    fi
done
unset IFS
