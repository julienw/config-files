#!/bin/bash
# Julien Wajsberg <jwajsberg@mozilla.com>
# gf aka "gaia flash"
# easily flash your gaia applications

# show all run commands
# set -x

# some things to put text in bold
bold=`tput smso`
offbold=`tput rmso`

# saving where we are
initialpwd=$(pwd)
make_command="install-gaia"

# parsing options
while getopts paoh opt ; do
  case $opt in
    a)
      flash_all=1
      ;;
    o)
      export GAIA_OPTIMIZE=1
      ;;
    h)
      echo "$(basename $0) [-p] [-a] [-h] [appName]"
      echo "  -a        force flashing all gaia"
      echo "  -o        optimize the build"
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
while test ! -r README.md -a ! $(pwd) == "/" ; do
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

echo "Trying to find the device image mode"
echo " (checking for device)"
adb wait-for-device
if adb shell cat /data/local/webapps/webapps.json | grep -qs '"basePath": "/system' ; then
  production=1
fi

if [ "$production" = "1" ] ; then
  export B2G_SYSTEM_APPS=1
  adb remount
fi

if [ -n "$BUILD_APP_NAME" ] ; then
  echo -n "Flashing ${bold}${BUILD_APP_NAME}${offbold} only"
else
  echo -n "Flashing ${bold}all${offbold} gaia"
fi

if [ "$production" = "1" ] ; then
  echo -n ", in ${bold}production${offbold} mode"
else
  echo -n ", in ${bold}dev${offbold} mode"
fi

if [ -n "$GAIA_OPTIMIZE" ] ; then
  echo -n ", ${bold}optimizing${offbold}"
fi

echo

read -p "Is this correct ? Press Ctrl-C to abort"

make ${make_command}

