require "uri"
require "rubygems"
require "rest_client"
require "json"

namespace :dodai do
  desc "Command interface for dodai-deploy."
  task :cli do
    server = ENV.fetch "server", ""
    resource_name = ENV.fetch "resource", ""
    action_name = ENV.fetch "action", ""
    params = ENV.fetch "params", ""

    if server == ""
      puts <<EOF
"dodai_server" was undefined. Please define the following environment variables.
  dodai_server: IP address or dns name of dodai server.
EOF
      break
    end

    site = RestClient::Resource.new("http://#{server}:3000/")
    resources = JSON.load site["rest_apis/index.json"].get 
    resource_names = resources.collect{|i| i["name"]}
    unless resource_names.include? resource_name
      resource_names_str = resource_names.join "\n  "
      puts <<EOF
Resource name wasn't provided or was wrong. Please provide a name of resource. The following resources could be used.
  #{resource_names_str}
EOF
      break
    end

    actions = resources.select{|i| i["name"] == resource_name}[0]["actions"]
    action_names = actions.collect{|i| i["name"]}
    unless action_names.include? action_name
      action_names_str = action_names.join "\n  "
      puts <<EOF
Action name wasn't provided or was wrong. Please provide a name of action. The following actions could be used.
  #{action_names_str} 
EOF
      break
    end

    action = actions.select{|i| i["name"] == action_name}[0]
    params = action.fetch "parameters", []
    params << "id" unless ["list", "create"].include? action_name
    failed = false
    params_str = params.join "\n  "
    params.each {|param|
      if ENV.fetch(param, "") == ""
        puts <<EOF
#{param} wasn't provided. The following parameters are necessary.
  #{params_str}
EOF
        failed = true
        break
      end
    }
    break if failed

    url, method, data = get_url_and_method_and_data resource_name, action_name, params

    if data == ""
      result = site[url].method(method).call
    else
      result = site[url].method(method).call(data)
    end

    if ENV.fetch("verbose", "") == "" and result != ""
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

    if ["install", "uninstall", "test"].include? action
        url = "#{resource}s/#{ENV["id"]}/#{action}.json"
    else
      if params.include? "id"
        url = "#{resource}s/#{ENV["id"]}.json"
      else
        url = "#{resource}s.json"
      end
    end

    params.delete "id"
    data = params.collect{|param| "#{resource}[#{URI.escape(param)}]=#{URI.escape(ENV[param])}"}.join "&" 
    [url, method, data]
  end
end
