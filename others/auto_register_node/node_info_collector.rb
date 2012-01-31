#!/usr/bin/ruby

require 'json'
require File.dirname(__FILE__) + '/utils'


def get_node_infos(network)
  split_str="---node_info---"
  node_infos = []
  node_info_strs=`mco rpc node info network=#{network} -v`.split("\n")
  node_info_strs.each {|node_info_str|
    if node_info_str.match(split_str)
      node_infos.push(node_info_str.split(split_str)[1])
    end
  } 
  return node_infos
end

network = ARGV.shift
cli = "ruby /usr/local/src/dodai-deploy/script/cli.rb --port 80"
node_infos = get_node_infos network
name_nodes = {}
JSON.parse(`#{cli} localhost node list`).each{|node| name_nodes[node["node"]["name"]] = node["node"]}
node_infos.each {|node_info|
  name, ip = node_info.split ":"

  old_ip = get_ip name
  if old_ip == ""
    add_host name, ip
  else
    update_host name, ip
  end

  puts name
  if not name_nodes.has_key? name 
    puts "Add node[#{name}]"
    `#{cli} localhost node create #{name}`
  else
    if ip != name_nodes[name]["ip"]
      puts "Update node[#{name}]"
      `#{cli} localhost node update #{name_nodes[name]["id"]} #{ip}`
    end
  end
}
