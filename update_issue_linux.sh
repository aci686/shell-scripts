#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__author_nick__="i686"
__copyright__="Aaron Castro"
__license__="MIT"

# Linux /etc/issue message

LOCALIPADDR=$(ip a | grep '^[0-9]' | awk -F':' '{print $2}' | grep -v 'lo' | while read -r iface; do echo -e "\t$iface: \4{$iface}";  done)

PUBLICIPADDR=$(echo -e "\t" $(curl http://ifconfig.io))

rm /etc/issue

cat << EOF > /etc/issue

\n running on \v

Local IP address:
$LOCALIPADDR

Public IP address:
$PUBLICIPADDR

EOF
