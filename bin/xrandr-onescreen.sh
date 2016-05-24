#!/bin/bash

exec 2>&1 > /var/log/xrandr.log

export DISPLAY=":0.0"
export XAUTHORITY="/home/judson/.Xauthority"
EXTERNAL_OUTPUT="VGA-1"
INTERNAL_OUTPUT="LVDS-1"

/usr/bin/xrandr -display ${DISPLAY} --output ${EXTERNAL_OUTPUT} --off
