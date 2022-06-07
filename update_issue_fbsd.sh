#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__author_nick__="i686"
__copyright__="Aaron Castro"
__license__="MIT"

# FreeBSD /etc/issue message

. /etc/rc.subr

networkinterface=$(ifconfig | awk -F':' '{print $1}' | grep -v 'lo0' | head -n1)
ipaddress=$(ifconfig $networkinterface | grep -w "inet" | awk '{print $2}')
echo -e "\n$networkinterface: $ipaddress" > /etc/issue
