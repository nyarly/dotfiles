#!/bin/bash

exec 2>&1 > /var/log/xrandr.log

# If an external monitor is connected, place it with xrandr

# External output may be "VGA" or "VGA-0" or "DVI-0" or "TMDS-1"
DISPLAY=":0"
EXTERNAL_OUTPUT="VGA-1"
INTERNAL_OUTPUT="LVDS-1"

echo "Before"
xrandr -display :0 -q

xrandr -display :0 -q |grep $EXTERNAL_OUTPUT | grep " connected "
if [ $? -eq 0 ]; then
    xrandr -display :0 --output $INTERNAL_OUTPUT --off --output $EXTERNAL_OUTPUT --auto
#    xrandr -display :0 --output $INTERNAL_OUTPUT --pos 0x150 --output $EXTERNAL_OUTPUT --auto --pos 1400x0
else
    xrandr -display :0 --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --off
fi

echo "After"
xrandr -display :0 -q
