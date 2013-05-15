#!/bin/bash
#
# Do some configurations for chris
#

# Clones a non-bare git repo or (if it already exists) fetches updates
# usage: getOrFetch <url> <localDir> [<gerritBranchToPush>]
cloneOrFetch() {
	if [ -d "$2" ] ;then
		gitDir="$2/.git"
		workTree="$2"
		[ ! -d "$2/.git" ] && gitDir="$2" && workTree=""
		if [ ! -z "$workTree" ] && [ $(git --git-dir "$gitDir" rev-parse --symbolic-full-name --abbrev-ref HEAD) == "master" ] ;then
			git --git-dir "$gitDir" --work-tree "$2" pull
		else
			git --git-dir "$gitDir" fetch --all
		fi
		[ -z "$workTree" ] || ( cd "$workTree" ; git submodule update --init --recursive )
	else
		if [ -f /media/sf_Shared/$(basename "$2").zip ] ;then
			unzip -q /media/sf_Shared/$(basename "$2").zip -d "$(dirname "$2")"
			cloneOrFetch "$1" "$2" "$3"
			return
		else
			git clone --recursive $1 "$2"
			gitDir="$2/.git"
			[ ! -d "$2/.git" ] && gitDir="$2"
		fi
	fi
	if [ ! -z "$3" ] ;then
		git config -f "$gitDir/config" remote.origin.push HEAD:refs/for/$3
		if [ ! -f "$gitDir/hooks/commit-msg" ] ;then
			curl -o "$gitDir/hooks/commit-msg" https://git.eclipse.org/r/tools/hooks/commit-msg
			chmod +x "$gitDir/hooks/commit-msg"
		fi
	fi
}

# while in the intranet set the correct proxy
if ping -c 1 proxy.wdf.sap.corp >/dev/null 2>&1 ;then
	export http_proxy=http://proxy:8080 https_proxy=https://proxy:8080 no_proxy='wdf.sap.corp,nexus,jtrack,127.0.0.1,localhost,*.wdf.sap.corp'
else
	unset http_proxy https_proxy no_proxy
fi

if [ -f ~/.netrc ] ;then
	echo "Don't write ~/.netrc because it already exists"
else
	read -s -p "Enter password for P1323864547 at servermetermeter-meter.prod.jpaas.sapbydesign.com: " epass
	echo -e "machine servermetermeter-meter.prod.jpaas.sapbydesign.com\nlogin P1323864547\npassword $epass" >> ~/.netrc
	echo
	read -s -p "Enter password for d032780 at git.wdf.sap.corp: " epass
	echo -e "machine git.wdf.sap.corp\nlogin d032780\npassword $epass" >> ~/.netrc
	echo
	read -s -p "Enter password for chalstrick at git.eclipse.org: " epass
	echo -e "machine git.eclipse.org\nlogin chalstrick\npassword $epass" >> ~/.netrc
	echo
	read -s -p "Enter password for chalstrick at github.com: " epass
	echo -e "machine github.com\nlogin chalstrick\npassword $epass" >> ~/.netrc
	chmod 600 ~/.netrc
fi

cloneOrFetch http://github.com/chalstrick/chrisFiles ~/git/chrisFiles && . ~/git/chrisFiles/git/setGitConfig.sh

if [ -f ~/.vimrc ] ;then
	echo "Don't write ~/.vimrc because it already exists"
else
	cp ~/git/chrisFiles/vim/_vimrc ~/.vimrc
fi

(cd ~/git/jgit && git config remote.origin.pushurl https://chalstrick@git.eclipse.org/r/jgit/jgit.git && git remote add github https://chalstrick@github.com/chalstrick/jgit.git && git fetch github)
(cd ~/git/egit && git config remote.origin.pushurl https://chalstrick@git.eclipse.org/r/egit/egit.git && git remote add github https://chalstrick@github.com/chalstrick/egit.git && git fetch github)
git config -f ~/git/egit-pde/.git/config remote.origin.pushurl https://chalstrick@git.eclipse.org/r/egit/egit-pde.git
git config -f ~/git/egit-github/.git/config remote.origin.pushurl https://chalstrick@git.eclipse.org/r/egit/egit-github.git
