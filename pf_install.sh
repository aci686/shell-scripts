#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

# Creates a basic PF firewall config

usage() {
    echo "Usage $0" 1>&2
    exit 0
}

sysrc pf_enable=yes
sysrc pflog_enable=yes
sysrc pflog_logfile="/var/log/pf.log"

cat << EOF >> /etc/pf.conf

set skip on lo0
set block-policy drop

block drop log all

pass in proto icmp
pass in log proto tcp to any port 22 keep state 

pass out all keep state

EOF

service pf start
service pflog start
