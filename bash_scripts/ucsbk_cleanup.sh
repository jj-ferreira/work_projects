#!/bin/bash

# This script clears up disk space from the /depot/ucs/ directory by deleting
# all backup files older than 45 days.


LOG_DIR="/depot/ucs/"
DAYS=45   # Date variable agreed upon by DC Engineering Team

find $LOG_DIR -type f \( -name "*.bin" -o -name "*.xml" \) -mtime $DAYS -exec rm -f {} \;
