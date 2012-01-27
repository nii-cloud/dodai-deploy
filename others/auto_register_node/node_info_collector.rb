#!/usr/bin/ruby

require 'json'
require File.dirname(__FILE__) + '/utils'


def get_node_infos(network)
  split_str="---node_info---"
  node_infos = []
  node_info_strs=`mco rpc get_node_ip get network=#{network} -v`.split("\n")
  node_info_strs.each {|node_info_str|
    if node_info_str.match(split_str)
      node_infos.push(node_info_str.split(split_str)[1])
    end
  } 
  return node_infos
end

network = ARGV.shift
cli = "ruby /usr/local/src/dodai-deploy/script/cli.rb"
node_infos = get_node_infos network
registed_node_names = JSON.parse(`#{cli} localhost node list`).collect{|node| node["node"]["name"]}
node_infos.each {|node_info|
  name, ip = node_info.split ":"

  old_ip = get_ip name
  if old_ip == ""
    add_host name, ip
  else
    update_host name, ip
  end

  if not registed_node_names.include? name 
    puts "Add node[#{name}]"
    `#{cli} localhost node create #{name}`
  end
}
