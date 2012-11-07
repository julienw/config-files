#!/bin/bash -e
# "gaia flash"
# easily flash your gaia applications

if test $(basename $(pwd)) != "gaia" ; then
    echo "ERROR : please go to your gaia directory"
    exit 1
fi

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

