#!/bin/bash

CLIMIT=85
CPU=`vmstat | tail -1 | awk '{print $15}'`
CPU_USE=$((100 - $CPU))
echo "CPU Usage is $CPU_USE"

if [ $CPU_USE -lt 5 ]
then
echo "CPU is barely used"
else
echo "Could use another vCPU"
fi
