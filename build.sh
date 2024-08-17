#!/bin/bash

# Define variables
REPO=https://github.com/v1cont
NAME=yad
VERSION=v14.1

# Convert NAME to lower case
PACKAGE_NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')

# Remove 'v' or 'V' if it is the first character
if [[ $VERSION == [vV]* ]]; then
    PACKAGE_VERSION="${VERSION:1}"
else
    PACKAGE_VERSION="$VERSION"
fi

if [ -d ./$PACKAGE_NAME-$PACKAGE_VERSION ]; then
    rm -rf ./$PACKAGE_NAME-$PACKAGE_VERSION
fi
# Clone Upstream using NAME
git clone $REPO/$NAME -b $VERSION
mv ./$NAME ./$PACKAGE_NAME-$PACKAGE_VERSION
if [ -d ./$PACKAGE_NAME-$PACKAGE_VERSION/debian ]; then
    rm -rf ./$PACKAGE_NAME-$PACKAGE_VERSION/debian
fi
cp -rvf ./debian ./$PACKAGE_NAME-$PACKAGE_VERSION
cd ./$PACKAGE_NAME-$PACKAGE_VERSION

# Create orig archive
tar czvf ../${PACKAGE_NAME}_${PACKAGE_VERSION}.orig.tar.gz .

# Get build dependencies
apt-get build-dep . -y

# Build package
dpkg-buildpackage -uc -us
