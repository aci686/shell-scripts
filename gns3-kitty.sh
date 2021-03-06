#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__author_nick__="i686"
__copyright__="Aaron Castro"
__license__="MIT"

# This starts a kitty listener that can be called to add tabs on it with a line like:
# kitty @ --to unix:/tmp/mykitty launch --type=tab --tab-title="%d" telnet %h %p
# Originally programmed so GNS3 can open tabbed console connections using kitty

kitty -o allow_remote_control=socket-only --listen-on unix:/tmp/mykitty &
