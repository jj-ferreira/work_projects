#!/bin/bash

LOG_DIR="/Users/joseferreira/Documents/bash_scripting/logs"
APP_LOG_FILE="application.log"
SYS_LOG_FILE="system.log"


echo -e "\n=========================="
echo "======analyzing log files======="
echo "==================="

echo -e "\nList of log files updated in last 24 hours"

find $LOG_DIR -name "*.log" -mtime -1

echo -e "\nsearching ERROR logs in application.log file"
grep "ERROR" "$LOG_DIR/$APP_LOG_FILE"

echo -e "\nnumber of ERROR logs found in application.log file"
grep -c "ERROR" "$LOG_DIR/$APP_LOG_FILE"

echo -e "\nnumber of FATAL logs found in application.log file"
grep -c "FATAL" "$LOG_DIR/$APP_LOG_FILE"

echo -e "\nnumber of FATAL logs found in system.log" 
grep -c "FATAL" "$LOG_DIR/$SYS_LOG_FILE"

echo -e "\nnumber of CRITICAL logs found in system.log"
grep -c "CRITICAL" "$LOG_DIR/$SYS_LOG_FILE"

echo -e "\nCRITICAL logs in system.log file"
grep "CRITICAL" "$LOG_DIR/$SYS_LOG_FILE"
