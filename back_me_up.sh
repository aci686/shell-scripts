#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__author_nick__="i686"
__copyright__="Aaron Castro"
__license__="MIT"

# Backs up $HOME to a specified destination CIFS drive

usage() {
    echo '[i] Usage: $0' 1>&2
    exit 0
}

ctrl_c() {
    echo -e '\n[!] Aborting...'
    tput cnorm
    exit 1
}

trap ctrl_c INT

DESTINATION='insert here your destination name' # will mount //$DESTINATION/$(whoami)/

echo '[i] Checking destination mountpoint...'
mount | grep $DESTINATION &> /dev/null
if [ $? == 0 ]; then
    echo '[!] Already mounted...'
    t_mtp=$(mount | grep $DESTINATION | awk '{print $3}')
    echo '[i] Reusing '$t_mtp'...'
else
    echo '[i] Creating temp mountpoint...'
    t_mtp=$(mktemp -d)
    echo '[i] '$t_mtp' created...'
    echo '[i] Mounting remote filesystem...'
    sudo mount -t cifs //$DESTINATION/$(whoami)/ $t_mtp -o username=$(whoami),uid=$(id -u),gid=$(id -g)
fi
echo '[i] Starting sync...'
rsync -aXv --omit-dir-times --backup-dir=versions --suffix="."$(date +"%d-%m-%Y") --ignore-errors --info=ALL --log-file=backup.$(date +"%d-%m-%Y").log --progress $HOME/ --exclude={".cache"} $t_mtp
echo '[OK] Sync complete!'
echo '[i] Unmounting...'
sudo umount $t_mtp

tput cnorm
