#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

# Spinner progress indicator
# Usage:
# Add the following at the beginning of your slow function:
#   tput civis
#   spinner &
#   spin_pid=$!
#   trap "kill -9 $spin_pid 2>/dev/null" $(seq 0 15)
# And add the following a the end of the slow function:
#   kill -9 $spin_pid 2>/dev/null
#   tput cnorm

spinner() {
    local i sp n
    case $((RANDOM % 12 )) in
    0)
        sp='-\|/' ;;
    1)
        sp='⠁⠂⠄⡀⢀⠠⠐⠈' ;;
    2)
        sp='▉▊▋▌▍▎▏▎▍▌▋▊▉' ;;
    3)
        sp='▁▂▃▄▅▆▇█▇▆▅▄▃▂▁' ;;
    4)
        sp='←↖↑↗→↘↓↙' ;;
    5)
        sp='┤┘┴└├┌┬┐' ;;
    6)
        sp='▖▘▝▗' ;;
    7)
        sp='⣾⣽⣻⢿⡿⣟⣯⣷' ;;
    8)
        sp='◴◷◶◵' ;;
    9)
        sp='◰◳◲◱' ;;
    10)
        sp='◐◓◑◒' ;;
    11)
        sp='◢◣◤◥' ;;
esac
    n=${#sp}
    while sleep 0.333
    do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

