#!/bin/bash

echo "Try to find master USB device"
IFS=$'\n'
for MOUNT in `df | sed "s/^ *//;s/ *$//;s/ \{1,\}/ /g" | cut --delimiter=" " -f6- | grep "/media/"`
    do 
      if [[ -f "$MOUNT/kiwix.exe" && -d "$MOUNT/data/" ]]
      then
	  DEVICE=`df | sed "s/^ *//;s/ *$//;s/ \{1,\}/ /g" | grep "$MOUNT$" | cut --delimiter=" " -f1`
	  break
      fi
      DEVICE=
done
unset IFS

if [ "$DEVICE" = "" ]
then
    echo "Unable to find a kiwix-plug USB key plugged :("
else
    echo "Found kiwix-plug USB key at $DEVICE. Starting dd..."
    sudo dd if="$DEVICE" of=./usb.dd bs=1M
    if [ "$?" = "0" ]
    then
	echo "USB disk image create successfuly!";
    else
	echo "Unable to create USB disk image!";
    fi
fi
