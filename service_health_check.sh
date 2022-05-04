#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

# Checks service health for a given list of systems

usage() {
    echo '[i] Usage: $0 [-i <ip address>...<ip address>...<ip address>...] [-s <service name>] [-u username]' 1>&2
    echo '[i] Usage: $0 [-f <source ip addresses file>] [-s <service name>] [-u <username>]' 1>&2
    exit 0
}

ctrl_c() {
    echo -e '\n[!] Aborting...'
    tput cnorm
    exit 1
}

trap ctrl_c INT

while getopts "i:f:s:u:" option; do
    case $option in
        #i ) ips+=("$OPTARG") ;;
        i ) ips=("$OPTARG")
            until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z $(eval "echo \${$OPTIND}") ]; do
                ips+=($(eval "echo \${$OPTIND}"))
                OPTIND=$((OPTIND + 1))
            done
            ;;
        f ) file="$OPTARG" ;;
        s ) service="$OPTARG" ;;
        u ) username="$OPTARG" ;;
        ? ) usage ;;
    esac
done

if [ -n "$ips" ] && [ -n "$file" ]; then
    usage
fi

if [ -n "$file" ]; then
    while read ip; do
        ips+=("$ip")
    done < $file
fi

if [ -z "$ips" ] || [ -z "$service" ]; then
    usage
fi

tput civis

. <(curl -sLo- https://raw.githubusercontent.com/aci686/shell-scripts/master/progressbar.sh)

echo ''

if [ -z "$username" ]; then
    username=$(id -u -n)
fi
read -sp '[?] Insert '"$username"' password [leave blank if you use id_rsa]: ' password

echo -e '\n'

bar::start
totalprogress=${#ips[@]}

for ip in "${ips[@]}"; do
    echo -en '[i] Checking '"$ip"' '"$service"' status... '
    timeout 5 sshpass -p "$password"  ssh -o StrictHostKeyChecking=no $username@$ip 'systemctl status '"$service"'' | grep 'running' &> /dev/null
    if [ $? == 0 ]; then
        echo -e '[OK]'
    else
        echo -e '[FAIL]'
    fi
    stepprogress=$((${stepprogress:-0}+1))
    bar::status_changed $stepprogress $totalprogress
done

bar::stop

tput cnorm
