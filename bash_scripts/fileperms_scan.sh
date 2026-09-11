# Script checks (/)root file system for files with RWX permissions for all users
# which is a known vulnerability. Outputs results to the ./filepermvulnresults.txt file
# For accurate results copy script to the /tmp directory run using sudo or root account

/bin/find / -type f -perm 777 > vulnresults.txt 2>/dev/null

if [[ -s vulnresults.txt ]]
then 
	echo "Files matching permissions vulnerability were found.  Please review the /tmp/vulnresults.txt file"
else
	echo "No files matching the permissions vulnerabiity were found on this server"
fi
