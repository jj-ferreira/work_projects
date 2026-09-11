#!/bin/bash

echo "Running Checks"

sleep 2

mem_check() {

	echo "*****Checking Memory*****"
	free -h
}


file_sys() {

	echo "*****Checking file system space*****"
	/bin/df -h
}

kernel_v() {

	echo "*****Checking Kernel Version*****"
	/bin/uname -r
}


mem_check
file_sys
kernel_v
