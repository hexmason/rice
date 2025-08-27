#!/bin/sh

xrandr --output HDMI1 --right-of eDP1
xrandr --output eDP1 --mode 1920x1080
xrandr --output HDMI1 --mode 1600x900

set-theme &
picom -b --experimental-backends --animations &
slstatus >/dev/null 2>&1 &
dwm 2>~/.dwm.log
