#!/usr/bin/env ruby

require "uri"
require "rubygems"
require "rest_client"
require "json"
require "optparse"

def get_url_and_method_and_data(resource, action, params)
  if ["list", "show", "install", "uninstall", "test"].include? action
    method = "get"
  elsif action == "create"
    method = "post"
  elsif action == "destroy"
    method = "delete"
  else
    method = "put"
  end

  if params.include? "id"
    id = ARGV.shift
    if ["install", "uninstall", "test"].include? action
      url = "#{resource}s/#{id}/#{action}.json"
    else
      url = "#{resource}s/#{id}.json"
    end
  else
    url = "#{resource}s.json"
  end

  params.delete "id"
  if resource == "log"
    data = params.collect{|param| "#{URI.escape(param)}=#{URI.escape(ARGV.shift)}"}.join "&"
  else
    data = params.collect{|param| "#{resource}[#{URI.escape(param)}]=#{URI.escape(ARGV.shift)}"}.join "&"
  end
  [url, method, data]
end

def clone_object(object, depth)
  return nil if depth == 0
  return nil if depth == 1 and (object.kind_of? Array or object.kind_of? Hash)

  if object.kind_of? Array
    new_object = object.collect{|i| clone_object i, depth - 1}.select{|i| i}
  elsif object.kind_of? Hash
    new_object = {}
    object.each{|key, value|
      new_value = clone_object value, depth - 1
      new_object[key] = new_value if new_value
    }
  elsif object.kind_of? String or object.kind_of? Integer
    new_object = object
  end

  return new_object
end

def print_usage
  puts <<EOF
Usage: ruby cli.rb [--verbose] [--port=PORT_NUMBER] SERVER RESOURCE ACTION [PARAM1 PARAM2 ...]
       OR
       ruby cli.rb SERVER list             -- List available resources and actions.

SERVER     : IP address or dns name of deploy server.
PORT_NUMBER: Port number of the rails server in deploy server. 
RESOURCE   : Resource name.
ACTION     : Action name, such as list, show, create, destroy.
--verbose  : Return details.
EOF
end

def print_list(resources)
  resource_action_names_str = resources.collect{|resource| 
    resource["name"] + "\n    " + resource["actions"].collect{|action| 
      action["name"] + " " + action.fetch("parameters", []).join(" ")
    }.join("\n    ")
  }.join("\n  ")

  puts <<EOF
Resources and corresponding actions are listed below.
  #{resource_action_names_str}
EOF

end

def validate_resource_name(resource_name, resources)
  resource_names = resources.collect{|i| i["name"]}
  unless resource_names.include? resource_name
    resource_names_str = resource_names.join "\n  "
    puts <<EOF
Resource name wasn't provided or was wrong. Please provide a name of resource. The following resources could be used.
  #{resource_names_str}
EOF

    return false 
  end

  return true 
end

def validate_action_name(action_name, actions)
  action_names = actions.collect{|i| i["name"] }
  unless action_names.include? action_name
    action_names_str = actions.collect{|i| i["name"] + " " + i.fetch("parameters", []).join(" ")}.join "\n  "
    puts <<EOF
Action name wasn't provided or was wrong. Please provide a name of action. The following actions could be used.
  #{action_names_str}
EOF

    return false 
  end

  return true 
end

def validate_parameters action_name, params
  params_str = params.join "\n  "
  if params.size > ARGV.size
    puts <<EOF
Parameters wasn't enough. The following parameters are necessary.
  #{params_str}
EOF
    return false
  end

  return true
end

OPTS = {}

opt = OptionParser.new
opt.on('--verbose') {|v| OPTS[:verbose] = v }
opt.on('--port [port]') {|v| OPTS[:port] = v}

begin
  opt.parse!(ARGV)
rescue
  print_usage
  exit
end

if ARGV.size < 1 
  print_usage
  exit 
end 

server = ARGV.shift
resource_name = ARGV.shift
action_name = ARGV.shift

port=OPTS.fetch :port, 3000
site = RestClient::Resource.new("http://#{server}:#{port}/")

resources = JSON.load site["rest_apis/index.json"].get
if resource_name == "list"
  print_list resources
  exit
end

exit 1 unless validate_resource_name resource_name, resources

actions = resources.select{|i| i["name"] == resource_name}[0]["actions"]
exit 1 unless validate_action_name action_name, actions

action = actions.select{|i| i["name"] == action_name }[0]
params = action.fetch "parameters", []
exit 1 unless validate_parameters action_name, params

url, method, data = get_url_and_method_and_data resource_name, action_name, params

if data == ""
  result = site[url].method(method).call
else
  result = site[url].method(method).call(data)
end

if !OPTS[:verbose] and result != ""
  depth = 3
  object = JSON.load(result)
  if object.kind_of? Array
    depth += 1
  end
  new_object = clone_object object, depth
  puts JSON.pretty_generate new_object
else
  puts result
end

