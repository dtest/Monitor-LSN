#!/bin/bash

# Author Derek Downey
# Copyright 2012
#
# Monitor LSN
#
# Connect to a running mysql server to check the current LSN value, sleep for an interval, and check the LSN value again.
# Calculate the MegaBytes (MB) per minute based on the start and end values, divided by a ratio to estimate the value over 60 seconds.

# Sleep Time is the first parameter accepted (in seconds)
sleepTime=$1

# TODO: allow mysql config options (host, user, etc)

# Default to 60, if parameter not provided or not an integer
if ! [[ "$1" =~ ^[0-9]+$ ]]
then 
    sleepTime=60
fi

# Initial sequence value
start=$(mysql -e 'SHOW ENGINE INNODB STATUS\G' | grep sequence | awk '{print $4}')

# Sleep for the interval
sleep $sleepTime

# Final sequence value
end=$(mysql -e 'SHOW ENGINE INNODB STATUS\G' | grep sequence | awk '{print $4}')

# Calculate the amount of megabytes per minute, adjusted to an estimated 60-second period
perMin=$(echo "scale=10;(($end-$start)/1024/1024)/($sleepTime/60)" | bc)

# Display the value
echo "$perMin MB_per_min"
