#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__author_nick__="i686"
__copyright__="Aaron Castro"
__license__="MIT"

# Progress bar

for ((k = 0; k <= 10 ; k++)); do
        echo -n "["
        for ((i = 0; i <= k; i++)); do
            echo -n "###"
        done
        for ((j = i; j <= 10; j++)); do
            echo -n "   "
        done
        v=$((k * 10))
        echo -n "] "
        echo -n "$v %" $'\r'
        sleep 0.70
    done
echo
