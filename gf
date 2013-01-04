#!/bin/bash
# Julien Wajsberg <jwajsberg@mozilla.com>
# gf aka "gaia flash"
# easily flash your gaia applications

# stopping at any error
set -e
# show all run commands
# set -x

# some things to put text in bold
bold=`tput smso`
offbold=`tput rmso`

# saving where we are
initialpwd=$(pwd)
make_command="install-gaia"

# parsing options
while getopts pah opt ; do
    case $opt in
        p)
            make_command="production"
            ;;
        a)
            flash_all=1
            ;;
        h)
            echo "$(basename $0) [-p] [-a] [-h] [appName]"
            echo "  -p         triggers production mode"
            echo "  -a        force flashing all gaia"
            echo "  -h        shows this help screen"
            echo "  appName   the app to flash"
            echo "Without any appName, this script tries to figure in which directory you are to flash this app"
            exit
            ;;
    esac
done

# getting the other parameters
shift $(( OPTIND-1 ))

echo "Finding gaia base directory..."
while test ! -r Makefile -a ! $(pwd) == "/" ; do
    cd ..
done

basepwd=$(pwd)

if test $(basename $basepwd) != "gaia" ; then
    echo "ERROR : please be inside your gaia directory"
    exit 1
fi

echo Found $basepwd

echo "Trying to find what you want to flash"
if test -z "$flash_all" ; then
    if test -n "$1" ; then
        echo "Was defined on the command line: $1"
        export BUILD_APP_NAME=$1
    elif [[ "$initialpwd" == */gaia/apps/* ]] ; then
        gaia_subdir=${initialpwd##$basepwd}
        export BUILD_APP_NAME=$(echo $gaia_subdir | awk -F/ -e '{ print $3 }')
    fi
fi

if [ -n "$BUILD_APP_NAME" ] ; then
    echo -n "Flashing ${bold}${BUILD_APP_NAME}${offbold} only, "
else
    echo -n "Flashing ${bold}all${offbold} gaia, "
fi

if [ "$make_command" = "production" ] ; then
    echo "in ${bold}production${offbold} mode"
else
    echo "in ${bold}dev${offbold} mode"
fi

read -p "Is this correct ? Press Ctrl-C to abord"

make ${make_command}

