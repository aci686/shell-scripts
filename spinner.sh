#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

# Spinner progress indicator
# Usage:
# Add the following at the beginning of your slow function:
#   spinner &
#   spin_pid=$!
#   trap "kill -9 $spin_pid 2>/dev/null" $(seq 0 15)
# And add the following a the end of the slow function:
#   kill -9 $spin_pid 2>/dev/null

spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    while sleep 0.333
    do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

