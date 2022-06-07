#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__author_nick__="i686"
__copyright__="Aaron Castro"
__license__="MIT"

# Port scan
# Uses echo to send empty strings to tcp ports
# Checks whether port is open or it is not

trap ctrl_c INT

ctrl_c() {
    echo "\n[!] Interrupted!\n"
    tput cnorm
    exit 1
}

usage() {
    echo "Usage: $0 [-i <ip address>] [-p <tcp port number>]" 1>&2
    exit 0
}

while getopts "i:p:" option; do
    case $option in
        p ) port="$OPTARG" ;;
        i ) ip="$OPTARG" ;;
        ? ) usage ;;
    esac
done

if [ -z "$port" ] || [ -z "$ip" ]; then
    usage
fi

tput civis
timeout 1 bash -c "echo '' > /dev/tcp/$ip/$port" 2>/dev/null && echo "[*] Port $port - OPEN" &
wait
tput cnorm
