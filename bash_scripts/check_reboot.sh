#!/bin/bash

# This script checks if a reboot is required after weekly update installation using dnf-automatic on RHEL 7/8 servers
# since dnf-automatic auto reboot option is not available on pre RHEL 9 servers. Script is kicked off via 
# a weekly cron job every Saturday morning at 6:00 AM

/bin/needs-restarting -r | grep -i "reboot should not be necessary"

if [ $? != 0 ]
then
	echo "Reboot is required following weekly patching.  Server is rebooting now!"
	/sbin/reboot
else
	echo "No reboot is required."
fi
