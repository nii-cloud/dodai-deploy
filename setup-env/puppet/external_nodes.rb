#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'net/http'
require 'yaml'
require 'active_support/core_ext'

hostname = ARGV[0]

path = "/etc/puppet/parameters"
parameters = YAML.load_file path

url = "http://localhost:PORT/node_configs/#{hostname}/puppet.json?" + parameters.to_query
data = Net::HTTP.get_response(URI.parse(url)).body

obj = JSON.parse data
File.open("/var/log/puppet/puppet.yml", "w") {|f| f.write JSON.pretty_generate obj}

puts YAML.dump obj 

exit 0 
