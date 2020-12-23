# Install-ts3-server-ubuntu-server-ARM
Install a teamsspeak3 server on ubuntu for ARM architecture with a bash script.
Created from the procedure described here :
https://www.raspberrypi.org/forums/viewtopic.php?t=275114

Before running this script, make sure you don't already have a custom schroot called streched64.
(The best usage for that installation script is to read it to be sure it doesn't badly interact with your system, and also in order to check if it is the last version of teamspeak 3 server)

To use this procedure, make sure your system is up to date, clone this repository and execute run-install-as-root.sh

Tested on Ubuntu server 20.04 and 20.10 and Rasperry Pi 4 model B (4 Go RAM)

NB : I suggest you should have a reboot procedure in the root crontab to renew the services. Example : contab -e and 0 5 * * * reboot
