#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

# Creates a basic IPtables firewall config
# Logs can be parsed by:
# tail -f /var/log/kern.log | grep '\[FW\]' | awk '{print $1" "$2" "$3" "$7" "$9" "$11" "$22" "$12" "$15" "$23" "$13" "$16" "$24}'

usage() {
    echo "Usage $0" 1>&2
    exit 0
}

apt install iptables-persistent conntrack

cat << EOF > /etc/iptables/rules.v4
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT DROP [0:0]

# Loopback
-A INPUT -i lo -j ACCEPT
-A OUTPUT -o lo -j ACCEPT


# Stateful firewall
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT


# Connectivity checking
-A INPUT -p icmp -j ACCEPT
-A OUTPUT -p icmp -j ACCEPT


# OUTSIDE -> SELF
-A INPUT -p tcp -m conntrack --ctstate NEW,ESTABLISHED --dport 22 -j LOG --log-prefix "[FW] ACTION=PERMIT "
-A INPUT -p tcp -m conntrack --ctstate NEW,ESTABLISHED --dport 22 -j ACCEPT -m comment --comment "Allow SSH management"


# SELF -> OUTSIDE
-A OUTPUT -j ACCEPT


# Logging
-A INPUT -j LOG --log-prefix "[FW] ACTION=DENY "
-A OUTPUT -j LOG --log-prefix "[FW] ACTION=DENY "


COMMIT
EOF

/usr/sbin/iptables-restore < /etc/iptables/rules.v4
