#!/bin/bash

# A script to control ts3 server:

# Create a named pipe, if it doesn't already exist:
pipe=/tmp/ts3pipe

if [ ! -p "$pipe" ]
then
        echo "No pipe called $pipe found, creating one!"
        mkfifo $pipe
fi

# Check if a screen named "ts3" is already running, if not, start it and schroot to the guest system inside it:
if (screen -ls | grep ts3)
then
        :
else
        echo "No screen running. Starting detached screen 'ts3'"
        screen -Sdm ts3 bash -c "exec bash"
        screen -S ts3 -X stuff 'schroot -c stretch64^M'
fi

# Execute the the given argument, marked with dollar-1:
screen -S ts3 -X stuff "sh /opt/teamspeak/ts3server_startscript.sh $@ >$pipe^M"

# Read the stdout from the pipe:
cat $pipe
