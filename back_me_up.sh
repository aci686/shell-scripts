#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__author_nick__="i686"
__copyright__="Aaron Castro"
__license__="MIT"

# Backs up $HOME to a specified rsync destination

usage() {
    echo "[i] Usage: $0 <username> <destination>" 1>&2
    exit 0
}

ctrl_c() {
    echo -e "\n[!] Aborting..."
    tput cnorm
    exit 1
}

trap ctrl_c INT

if [ $# -ne 2 ]; then
    usage
fi

echo "[i] Starting sync..."
rsync -aXv --omit-dir-times --backup-dir=versions --suffix="."$(date +"%d-%m-%Y") --ignore-errors --no-perms --info=ALL --log-file=backup.$(date +"%d-%m-%Y").log --progress $HOME/ --exclude={"$HOME/.cache"} $1@$2
echo "[OK] Sync complete!"

tput cnorm
