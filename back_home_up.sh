#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

# Backs up $HOME to a mounted USB HDD

exitcode=1

# do check if usb hdd is mounted
echo "CHECKING IF USB HDD IS AVAILABLE..."
if test -e '/media/usb0/'; then
exitcode=0
# from home folder to usb hdd if local files are newer
echo "SYNCING UP FROM PC TO USB HDD :: User's Home Folder"
rsync -avu --inplace --info=progress2 --info=name0 --delete-before $HOME /media/usb0/
# from usb hdd to home folder if usb hdd files are newer
# echo "SYNCING UP FROM USB HDD TO PC"
# rsync -avu --inplace --info=progress2 --info=name0 /media/usb0/ /home/User/
else
# if the usb hdd is not mounted exit wit exitcode=1
echo "USB HDD NOT MOUNTED!"
fi
exit $exitcode
