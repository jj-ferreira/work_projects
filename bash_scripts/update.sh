#!/bin/bash

# Script used to update date/time whenever I suspend my VM.
# Followed up DNF update
# Must be run by root 

if [[ $EUID -ne 0 ]]
then
	echo "Switch to root"
	exit 1
fi

echo "VM was suspended so it needs to have its time updated"

systemctl restart chronyd.service

echo "Now that the time has been updated ... Proceeding with update installation"

/bin/dnf update -y
