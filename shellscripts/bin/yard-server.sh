#!/bin/bash

GEM_PATH_19=/usr/local/lib/ruby/gems/1.9.1:/usr/lib/ruby/gems/1.9.1:/home/judson/ruby/bundle-paths/rails3/lib/ruby/1.9.1
GEM_PATH_20=/usr/local/lib/ruby/gems/2.0.0:/usr/lib/ruby/gems/2.0.0:/home/judson/ruby/bundle-paths/rails3/lib/ruby/2.0.0

cd /var/www/yard

if eselect ruby show | grep -q "ruby19"; then
  GEM_PATH="$GEM_PATH_19:$GEM_PATH_20" yard server --gems --private --protected
else
  GEM_PATH="$GEM_PATH_20:$GEM_PATH_19" yard server --gems --private --protected
fi
