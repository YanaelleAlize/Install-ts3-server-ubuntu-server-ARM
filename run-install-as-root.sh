#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Please run this script with root privileges"
    exit
fi

echo START Downloading dependencies ...
apt install debootstrap qemu qemu-user-static schroot binfmt-support 
apt install bzip2
adduser --disabled-login teamspeak
echo END Downloading dependencies

echo START Creating amd64 emulator ...
#mkdir /srv
mkdir /srv/chroot
mkdir /srv/chroot/stretch64
qemu-debootstrap --arch=amd64 stretch /srv/chroot/stretch64
cp configs/stretch64 /etc/schroot/chroot.d/stretch64
mv /etc/schroot/default/fstab /etc/schroot/default/fstab.back
cp configs/fstab /etc/schroot/default
echo END Creating amd64 emulator

echo START Dowloading and setting up ts3 server ...

mkdir /opt/teamspeak
cp scripts/ts3.sh /opt/teamspeak
chown -Rf teamspeak /opt/teamspeak
chmod a+x /opt/teamspeak/ts3.sh

mkdir /srv/chroot/stretch64/opt
mkdir /srv/chroot/stretch64/opt/teamspeak

mkdir tmp
cd tmp
# latest version @2020/11/16 - 3.13.1
wget https://files.teamspeak-services.com/releases/server/3.13.1/teamspeak3-server_linux_amd64-3.13.1.tar.bz2
tar -xjf teamspeak3-server_linux_amd64-3.13.1.tar.bz2
cd teamspeak3-server_linux_amd64
mv * /srv/chroot/stretch64/opt/teamspeak
touch /srv/chroot/stretch64/opt/teamspeak/.ts3server_license_accepted
chown -Rf teamspeak /srv/chroot/stretch64/opt/teamspeak
cd ../..
rm -rf tmp

#cp configs/teamspeak3server.service /lib/systemd/system/
#systemctl enable teamspeak3server.service

#create teamspeak crontab to launch the server on startup
cp configs/teamspeak_crontab /var/spool/cron/crontabs/teamspeak

echo END Dowloading and setting up ts3 server

echo START Testing server
echo You should save the info of the TS3 server
sleep 5
cd /
su - teamspeak -c "schroot -c stretch64 -u root -- sh -c '/opt/teamspeak/ts3server_startscript.sh start'"
#su - teamspeak -c "/opt/teamspeak/ts3.sh start"
sleep 5
exit
echo Now you can reboot your system and enjoy your newly installed ts3 server.
echo END Testing server
exit
