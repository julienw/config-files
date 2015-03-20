#!/bin/bash
# Julien Wajsberg <jwajsberg@mozilla.com>
# gf aka "gaia flash"
# easily flash your gaia applications

# show all run commands
#set -x

# stop at the first error
set -e

# some things to put text in bold
bold=`tput smso`
offbold=`tput rmso`

# saving where we are
initialpwd=$(pwd)
make_command="install-gaia"

#nit_dir="$(dirname /home/julien/bin/gf)"; target_dir="" finding where I am installed
# can't use readlink -f to stay compatible with MacOS X

init_dir="$(dirname "$0")"
target_dir="$(dirname "$(readlink "$0")")"

basedir="$(cd $init_dir && cd $target_dir && pwd -P)"

# parsing options
while getopts aopeh opt ; do
  case $opt in
    a)
      flash_all=1
      ;;
    o)
      export GAIA_OPTIMIZE=1
      ;;
    p)
      production=1
      ;;
    e)
      production=0
      ;;
    h)
      echo "$(basename $0) [-a] [-o] [-h] [-e | -p] [appName]..."
      echo "  -a        force flashing all gaia"
      echo "  -o        optimize the build"
      echo "  -p        force pushing to /system (production mode)"
      echo "  -e        force pushing to /data (eng mode)"
      echo "  -h        shows this help screen"
      echo "  appName   the app(s) to flash"
      echo "Without any appName, this script tries to figure in which directory you are to flash this app"
      exit
      ;;
  esac
done

# getting the other parameters
shift $(( OPTIND-1 ))

echo "Finding gaia base directory..."
while test ! -d .git -a ! $(pwd) == "/" ; do
  cd ..
done

gaiabasepwd=$(pwd)
gaiabasedir=$(basename $gaiabasepwd)
if test "${gaiabasedir#gaia}" == "$gaiabasedir" ; then
  echo "ERROR : please be inside your gaia directory"
  exit 1
fi

echo Found $gaiabasepwd

echo "Checking for device..."
adb wait-for-device

if [ -z "$production" ] ; then
  echo "Trying to find the device image mode"
  if adb shell cat /data/local/webapps/webapps.json | grep -qs '"basePath": "/system' ; then
    production=1
  fi
fi

echo "Trying to find the device's name"
# note: adb shell getprop seems to end lines with \r which is not trimmed by bash
device_name=$(adb shell getprop ro.product.device | sed 's/\s*$//')
dpi_file="$basedir/devices/dpi/__default"

if [ -n "$device_name" ] ; then
  echo "Found $device_name"
  device_dpi_file="$basedir/devices/dpi/$device_name"
  if [ -r "$device_dpi_file" ] ; then
    dpi_file="$device_dpi_file"
  fi
fi

dpi=$(cat "$dpi_file")
export GAIA_DEV_PIXELS_PER_PX=$dpi

if [ "$production" = "1" ] ; then
  export GAIA_INSTALL_PARENT=/system/b2g
  adb remount
else
  export GAIA_INSTALL_PARENT=/data/local
fi

do_flash() {
  appname="$1";
  if [ -n "$appname" ] ; then
    echo -n "Flashing ${bold}${appname}${offbold} only"
    export BUILD_APP_NAME="$appname"
  else
    echo -n "Flashing ${bold}all${offbold} gaia"
  fi

  if [ "$production" = "1" ] ; then
    echo -n ", in ${bold}production${offbold} mode"
  else
    echo -n ", in ${bold}eng${offbold} mode"
  fi

  if [ -n "$GAIA_OPTIMIZE" ] ; then
    echo -n ", ${bold}optimizing${offbold}"
  fi

  if [ "$dpi" != "1" ] ; then
    echo -n ", with ${bold}@${dpi}x${offbold} assets"
  fi

  echo

  if [ -z "$appname" ] ; then
    read -p "Is this correct ? Press Ctrl-C to abort"
  fi

  make ${make_command}
}

# In case the adb daemon was not started in root
adb root

echo "Trying to find what you want to flash"
if test -z "$flash_all" ; then
  if test -n "$1" ; then
    echo "Was defined on the command line: $*"
    while test -n "$1" ; do
      do_flash $1
      shift
    done
  elif [[ ( "$initialpwd" == */$gaiabasedir/apps/* ) || ( "$initialpwd" == */$gaiabasedir/test_apps/* ) ]] ; then
    gaia_subdir=${initialpwd##$gaiabasepwd}
    do_flash $(echo $gaia_subdir | awk -F/ '{ print $3 }')
  fi
fi


