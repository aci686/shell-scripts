#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

# Uses Supermicro IPMI BMC Shell to send commands
# Right now only power clycle commands are implemented

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"


usage() {
    echo "Usage: $0 [-p <up|down>] [-h <ip address | hostname>]" 1>&2
    exit 0
}

powerup() {
    echo "start /system1/pwrmgtsvc1" | ssh -T root@$1
}

powerdown() {
    echo "stop /system1/pwrmgtsvc1" | ssh -T root@$1
}

while getopts "p:i:" option; do
    case $option in
        p ) power="$OPTARG" ;;
        i ) ip="$OPTARG" ;;
        ? ) usage ;;
    esac
done

if [ -z "$power" ] || [ -z "$ip" ]; then
    usage
fi

case $power in
    "up" ) powerup "$ip" ;;
    "down" ) powerdown "$ip" ;;
    * ) usage ;;
esac
