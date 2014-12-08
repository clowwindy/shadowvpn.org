#!/bin/bash

CD=$(pwd)
CH=/home/chroot/wheezy
TAG=$1

if [ `id -u` -ne 0 ]; then
	echo "The script requires root privileges."
	exit 2
fi

rm -rf $CD/dists/wheezy/main/binary-amd64 $CD/dists/wheezy/main/binary-i386
cd /tmp
rm -rf ShadowVPN
git clone https://github.com/clowwindy/ShadowVPN.git
cd ShadowVPN
git submodule update --init
if [ -n "$TAG" ]; then
	git checkout $TAG || exit 0
fi
./autogen.sh
dpkg-buildpackage -us -uc -d
mv -f ../shadowvpn_*.tar.gz $CH/tmp

bashrc=$(cat $CH/root/.bashrc)

cat <<-EOF > $CH/root/.bashrc
	export LANGUAGE=en_US.UTF-8
	export LANG=en_US.UTF-8
	export LC_ALL=C
	cd /tmp
	rm -rf ShadowVPN
	tar xzf shadowvpn_*.tar.gz
	cd ShadowVPN
	dpkg-buildpackage -us -uc -d
	rm -f ../shadowvpn_*.tar.gz
	exit 0
EOF

chroot $CH

cat <<-EOF > $CH/root/.bashrc
	$bashrc
EOF

mkdir -p $CD/dists/wheezy/main/binary-amd64
mkdir -p $CD/dists/wheezy/main/binary-i386
mv -f /tmp/shadowvpn_* $CD/dists/wheezy/main/binary-amd64/
mv -f $CH/tmp/shadowvpn_* $CD/dists/wheezy/main/binary-i386/

cd $CD
if [ -f ./update.sh ]; then
	. ./update.sh
fi
