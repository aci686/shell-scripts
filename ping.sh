#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

# Ping script

source isip.sh
source symbols.sh

usage() {
    echo "Usage: $0 <hostname | ip address>" 1>&2
    exit 0
}

if [ -z $1 ]; then usage; fi

isip $1 &> /dev/null
if [ $? == 1 ]; then
    ping $1 -c 1 -W 1 &> /dev/null
    if [ $? == 0 ]; then
        echo -e "[${check1}]"
    else
        echo -e "[${missing1}]"
    fi
else
    address=$(host $1 | head -n 1 | awk '{print $4}')
    if [ $address != "found:" ]; then
        ping $address -c 1 -W 1 &> /dev/null
        if [ $? == 0 ]; then
            echo -e "[${check1}]"
        else
            echo -e "[${missing1}]"
        fi
    else
        echo -e "[${missing1}]"
    fi
fi