#!/bin/bash


BACKUP_DIR="/backups"
BKLOG_FILE="/backups/backup_log.txt"

if [ ! -d "$BACKUP_DIR" ];
then
mkdir -p "$BACKUP_DIR"
fi



read -p "Please enter full patch for the directory you want to backup:" target_dir

if [ ! -d "$target_dir" ];
then
echo "Error: Directory does not exist."
exit 1
fi
