#!/bin/bash

i3-msg -t get_tree | jsonlint > ~judson/.i3/i3tree.two.json
