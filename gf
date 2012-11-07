#!/bin/bash -e
# "gaia flash"
# easily flash your gaia applications

echo "Finding gaia base directory..."
while test ! -r Makefile -a ! $(pwd) = "/" ; do
    cd ..
done


if test $(basename $(pwd)) != "gaia" ; then
    echo "ERROR : please be inside your gaia directory"
    exit 1
fi

echo Found $(pwd)

while getopts p opt ; do
    case $opt in
        p)
            export PRODUCTION=1
            adb remount
            ;;
    esac
done

export BUILD_APP_NAME=$1

make install-gaia

