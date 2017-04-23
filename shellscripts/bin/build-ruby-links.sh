#!/bin/bash

for ruby in /usr/bin/ruby??; do
  case $ruby in
    *18)
      rubyname=$($ruby --version | sed 's/ruby \(\S\+\).*patchlevel \([0-9]\+\).*/ruby-\1-p\2/')
      ;;
    *)
      rubyname=$($ruby --version | sed 's/ruby \(\S\+\)p\([0-9]\+\).*/ruby-\1-p\2/')
      ;;
  esac
  sudo mkdir -p /opt/rubies/$rubyname/bin
  sudo ln -sf $ruby /opt/rubies/$rubyname/bin/ruby
  sudo ln -sf /usr/bin/gem$(echo $ruby | sed 's!/usr/bin/ruby!!') /opt/rubies/$rubyname/bin/gem
done
