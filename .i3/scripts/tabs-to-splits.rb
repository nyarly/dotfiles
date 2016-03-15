#!/usr/bin/env ruby
#
require 'json'
require 'pp'
require_relative './parsing-functions'

tree = JSON.parse(%x{i3-msg -t get_tree})

path = find_focused([], tree).reverse
path.shift
path = path.drop_while{|tree| ["tabbed", "stacked"].include? tree["layout"] }

root = path.first

each_node(root["nodes"]) do |node|
  case node["layout"]
  when "tabbed"
    puts "tabbed to splitv"
    %x"i3-msg '[con_id=#{node["id"]}] layout splitv'"
  when "stacked"
    puts "stacked to splith"
    %x"i3-msg '[con_id=#{node["id"]}] layout splith'"
  else
  end
end

%x"i3-msg '[con_id=#{root["id"]}] focus'"
