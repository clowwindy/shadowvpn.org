#!/bin/bash

PACKAGE=dists/wheezy/main

# Build package info
mkdir -p $PACKAGE/binary-amd64
dpkg-scanpackages $PACKAGE/binary-amd64 /dev/null > $PACKAGE/binary-amd64/Packages
dpkg-scanpackages $PACKAGE/binary-amd64 /dev/null | gzip -9c > $PACKAGE/binary-amd64/Packages.gz

pushd dists/wheezy/

# Create Release
cat > Release <<EOM
Origin: ShadowVPN
Label: ShadowVPN
Architectures: amd64
Components: main
Suite: wheezy
Description: ShadowVPN APT Repository
EOM
apt-ftparchive release . >> Release

popd
