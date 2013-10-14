#!/bin/bash
#
# Configure a Eclipse on a ubuntu system to my needs
#

# install java
sudo -E apt-get -q=2 install openjdk-7-{jdk,doc,source} 

# install eclipse
if [ ! -x /usr/bin/eclipse ] ;then
	eclipseUrl='http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/kepler/SR1/eclipse-jee-kepler-SR1-linux-gtk.tar.gz&r=1'
	if [ $(uname -m) == "x86_64" ] ;then
		eclipseUrl='http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/kepler/SR1/eclipse-jee-kepler-SR1-linux-gtk-x86_64.tar.gz&r=1'
	fi
	tmp=$(mktemp -d)
	wget -qO- "$eclipseUrl" | tar -C $tmp -xz
	sudo mv $tmp/eclipse /opt/eclipse
	rm -fr $tmp
	sudo chown -R $USER:$USER /opt/eclipse
	sudo ln -s /opt/eclipse/eclipse ~/bin/
	if [ ! -L ~/Desktop/eclipse ] ;then
		ln -s /opt/eclipse/eclipse ~/Desktop/ 
	fi
fi

# prepare API Baselines
mkdir -p ~/egit-releases
rel=org.eclipse.egit.repository-3.1.0.201310021548-r
if [ ! -d ~/egit-releases/$rel ] ;then
	wget -q http://download.eclipse.org/egit/updates-3.1/$rel.zip && unzip -q $rel.zip -d ~/egit-releases/$rel && rm $rel.zip
fi
