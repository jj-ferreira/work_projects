#!/bin/bash


echo "****************Server Health Report***************"


echo "System time is:" $(date)


server_name=$(hostnamectl | awk '/Static hostname:/ {print $3}')

echo "Server name is:"  $server_name

echo "Server disk utilization:" 

df -h
