#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

# This script needs libnotify-bin to work as it relies on notify-send command
# We can use this script to send desktop notifications to all users logged in using any X display
# notify-send uses the following syntax:
# notify-send --urgency=[low|normal|critical] --expire-time 1 --icon=[icon_file] "Subject" "Message"
# Refer to notify-send man page for additional details
# [icon_file] should be some located at /usr/share/icons/gnome/32x32/ and its subfolders
#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

PATH=/usr/bin:/bin

XUSERS=($(who|grep -E "\(:[0-9](\.[0-9])*\)"|awk '{print $1$5}'|sort -u))
for XUSER in $XUSERS; do
	NAME=(${XUSER/(/ })
	DISPLAY=${NAME[1]/)/}
	DBUS_ADDRESS=unix:path=/run/user/$(id -u ${NAME[0]})/bus
	sudo -u ${NAME[0]} DISPLAY=${DISPLAY} DBUS_SESSION_BUS_ADDRESS=${DBUS_ADDRESS} PATH=${PATH} notify-send "$@"
done
