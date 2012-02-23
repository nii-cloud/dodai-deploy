#!/usr/bin/ruby

require 'json'
require File.dirname(__FILE__) + '/utils'
require "mcollective"
include MCollective::RPC

def get_node_infos(network)
  options = {:filter=>{"identity"=>[], "fact"=>[], "agent"=>[], "cf_class"=>[]},
     :collective=>nil,
     :config=>"/etc/mcollective/client.cfg",
     :disctimeout=>5,
     :verbose=>true,
     :progress_bar=>false,
     :timeout=>60
  }

  mc = rpcclient "node", :options => options
  output = mc.info :network => network
  mc.disconnect

  p output

  output.collect {|item| item.results[:data]}
end

network = ARGV.shift
cli = "ruby /usr/local/src/dodai-deploy/script/cli.rb --port 80"
node_infos = get_node_infos network
node_infos_str = JSON.pretty_generate node_infos
File.open("/etc/dodai/node_infos", 'w') {|f| f.write(node_infos_str)}

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
