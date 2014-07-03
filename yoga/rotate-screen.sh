#!/bin/bash

# Script rotates screen 90deg on every run, and also rotates touchscreen and wacom input.
# If argument normal|left|right|inverted is given, go directly into that oriantation

current_screen() {
  LC_ALL=C xrandr | grep " connected" | awk '{print $1}'
}

current_orientation(){
  xrandr|grep " connected" |awk '{print $5}'
}
rotate_left(){
  xrandr -o left
  xsetwacom set "Wacom ISDv4 EC Pen stylus" rotate ccw
  xsetwacom set "Wacom ISDv4 EC Pen eraser" rotate ccw
  xinput set-prop "ELAN Touchscreen" "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
}
rotate_right(){
  xrandr -o right
  xsetwacom set "Wacom ISDv4 EC Pen stylus" rotate cw
  xsetwacom set "Wacom ISDv4 EC Pen eraser" rotate cw
  xinput set-prop "ELAN Touchscreen" "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
}
rotate_inverted(){
  xrandr -o inverted
  xsetwacom set "Wacom ISDv4 EC Pen stylus" rotate half
  xsetwacom set "Wacom ISDv4 EC Pen eraser" rotate half
  xinput set-prop "ELAN Touchscreen" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
}
rotate_normal(){
  xrandr -o normal
  xsetwacom set "Wacom ISDv4 EC Pen stylus" rotate none
  xsetwacom set "Wacom ISDv4 EC Pen eraser" rotate none
  xinput set-prop "ELAN Touchscreen" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
}

orientation=$(current_orientation)

# if the orientation argument was given to this script, sets orientation variable 
# according to the way we want to rotate in next loop.
if [ -n "$1" ]; then
  if [ "$1" == "normal" ]; then
    orientation="right"
  fi
  if [ "$1" == "left" ]; then
    orientation="(normal"
  fi
  if [ "$1" == "right" ]; then
    orientation="inverted"
  fi
  if [ "$1" == "inverted" ]; then
    orientation="left"
  fi
fi

# turns 90° counter-clockwise
case $orientation in
  "(normal" )
  rotate_left
  ;;
"inverted" )
  rotate_right
  ;;
"right" )
  rotate_normal
  ;;
"left" )
  rotate_inverted
  ;;
* )
  echo "c est autre chose"
  exit 1
  ;;
esac

exit 0
