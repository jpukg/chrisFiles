#!/bin/bash
#
# Configure a Debian based Linux to work properly as a VirtualBox guest

# install applications
sudo -E apt-get -q=2 update
sudo -E apt-get -q=2 install dkms

# install guest additions (after dkms)
[ -x /media/$USER/VBOXADDITIONS*/VBoxLinuxAdditions.run ] && sudo -E /media/$USER/VBOXADDITIONS*/VBoxLinuxAdditions.run

# add user to group which is allowed to read shared folders
id -G -n | grep vbox || sudo adduser $USER vboxsf
