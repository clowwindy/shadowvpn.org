#!/bin/bash

PACKAGE=dists/wheezy/main
ARCH="i386 amd64"

# Build package info
for arch in $ARCH; do
	mkdir -p $PACKAGE/binary-$arch
	dpkg-scanpackages $PACKAGE/binary-$arch /dev/null > $PACKAGE/binary-$arch/Packages
	cat $PACKAGE/binary-$arch/Packages | gzip -9c > $PACKAGE/binary-$arch/Packages.gz
done

pushd dists/wheezy/

# Create Release
cat <<-EOM > Release
	Origin: ShadowVPN
	Label: ShadowVPN
	Architectures: $ARCH
	Components: main
	Suite: wheezy
	Description: ShadowVPN APT Repository
EOM

apt-ftparchive release . >> Release

popd
