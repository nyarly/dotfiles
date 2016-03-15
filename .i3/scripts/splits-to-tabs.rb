#!/usr/bin/env ruby
#
require 'json'
require 'pp'
require_relative './parsing-functions'

tree = JSON.parse(%x{i3-msg -t get_tree})

path = find_focused([], tree).reverse

root = path.first

each_node([root]) do |node|
  next if node["nodes"].length == 0
  case node["layout"]
  when splith
    puts "splith to tabbed"
    %x"i3-cmd '[con_id=#{node["id"]}] layout tabbed'"
  when splitv
    puts "splitv to stacking"
    %x"i3-cmd '[con_id=#{node["id"]}] layout stacking'"
  end
end
