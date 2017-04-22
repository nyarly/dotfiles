#!/bin/sh

i3-msg append_layout ~/.i3/layouts/main-work.json
nohup urxvtc &
nohup chromium &
