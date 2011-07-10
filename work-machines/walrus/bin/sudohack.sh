#!/bin/bash
echo "waiting for 15 seconds..." 
sleep 15

while [ true ]; do
	#sudo -u root /bin/true > /dev/null 2> /dev/null
	sudo echo "$0 keep sudo" > /dev/null
	sleep 60
done
		
