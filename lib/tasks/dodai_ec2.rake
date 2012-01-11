namespace :dodai do
  desc 'Add copyright header'
  task :copyright do

    copyright = <<EOF
#
# Copyright 2011 National Institute of Informatics.
#
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
EOF

    Dir.glob("**/*") do |path|
      if path =~ /.*\.rb/
        f = open path
        content = f.read
        f.close
        unless content.strip =~ /^#/
          f = File.open path, "w"
          f.write copyright + content
          f.close

          puts path
        end
      end
    end
  end


  desc 'Equal to dodai:ec2:all'
  task :ec2 do
    Rake::Task["dodai:ec2:all"].invoke
  end

  namespace :ec2 do
    def get_erb_template_from_file_content(path)
      path = File.dirname(__FILE__) + "/templates/" + path if Pathname.new(path).relative?
      puts path
      file = open path
      template = ERB.new file.read
      file.close
    
      template
    end

    def validate_parameters(parameters)
      parameters_str = parameters.collect{|parameter| "#{parameter[0]}: #{parameter[1]}"}.join("\n    ")
      result = (parameters.collect{|parameter| parameter[0]} - ENV.reject{|key, value| value.strip == ""}.keys).size == 0
      unless result
        puts <<EOF
Usage:

  rake dodai:ec2 | dadai:ec2:all nodes_size=NODES_SIZE [server_port=SERVER_PORT]
  rake dodai:ec2:server [server_port=SERVER_PORT]
  rake dodai:ec2:nodes nodes_size=NODES_SIZE server_fqdn=SERVER_FQDN server_dns_name=SERVER_DNS_NAME

  NODES_SIZE     : The number of dodai-deploy nodes to be started.
  SERVER_FQDN    : The fqdn of dodai-deploy server, which can be confirmed with command "hostname -f".
  SERVER_DNS_NAME: The IP address or dns name of dodai-deploy server.
  SERVER_PORT    : The port number of dodai-deploy server. The default value is 3000.

  The following variables should be defined in environment.
    #{parameters_str}

  The following variables are optional.
    ec2_endpoint_url: EC2 end point url
    ec2_region: EC2 region
  Please refer to lib/tasks/dodai_ec2rc for values.
EOF

      end

      result
    end

    def convert_to_private_dns_name(ip)
      if ip =~ /^[0-9.]*$/ # ip is IP address.
        private_dns_name = "ip-" + ip.gsub(/\./, "-")
      else #ip is dns name.
        ip 
      end
    end

    parameters = [
      ["ec2_access_key_id", "EC2 access key id"],
      ["ec2_secret_access_key", "EC2 access key"],
      ["ec2_key_pair", "EC2 key pair"],
      ["ec2_security_group", "EC2 security group"],
      ["ec2_image_id", "EC2 image id. It should be the image id of ubuntu 10.10, 11.04 or 11.10."],
      ["ec2_instance_type", "EC2 instance type. It should the type which can be used for the image specified in image_id."],
    ]

    access_key_id = ENV["ec2_access_key_id"]
    secret_access_key = ENV["ec2_secret_access_key"]
    image_id = ENV["ec2_image_id"]
    key_pair = ENV["ec2_key_pair"]
    security_group = ENV["ec2_security_group"]
    instance_type = ENV["ec2_instance_type"]
    endpoint_url = ENV.fetch "ec2_endpoint_url", "" 
    region = ENV.fetch "ec2_region", ""
    server_fqdn = "" 
    server_dns_name = ""
    server_port = ""
    node_private_dns_names = []
 
    ec2 = nil

    def create_ec2_connection(access_key_id, secret_access_key, endpoint_url = "", region = "")
      if endpoint_url.strip != ""
        ec2 = RightAws::Ec2.new access_key_id, secret_access_key, :endpoint_url => endpoint_url, :logger => Logger.new(STDOUT) 
      else
        if region.strip != ""
          ec2 = RightAws::Ec2.new access_key_id, secret_access_key, :region => region, :logger => Logger.new(STDOUT)
        else
          ec2 = RightAws::Ec2.new access_key_id, secret_access_key, :logger => Logger.new(STDOUT)
        end
      end
    end


    desc 'Set up a dodai-deploy server and nodes on ec2, and add the nodes to the server.'
    task :all do
      break unless validate_parameters parameters

      if ENV.fetch("nodes_size", "") == ""
        puts <<EOF
Please specify nodes_size such as the following example.
  rake dodai:ec2 nodes_size=1
EOF
        break
      end
      Rake::Task["dodai:ec2:start_server"].invoke
      Rake::Task["dodai:ec2:start_nodes"].invoke

      Rake::Task["dodai:ec2:wait_server"].invoke
      Rake::Task["dodai:ec2:wait_nodes"].invoke
    end

    desc 'Set up dodai-deploy nodes on ec2, and add the nodes to the dodai-deploy server specified.'
    task :nodes do 
      Rake::Task["dodai:ec2:start_nodes"].invoke
      Rake::Task["dodai:ec2:wait_nodes"].invoke
    end

    desc 'Set up a dodai-deploy server on ec2.'
    task :server do
      Rake::Task["dodai:ec2:start_server"].invoke
      Rake::Task["dodai:ec2:wait_server"].invoke
    end

    task :start_nodes do
      break unless validate_parameters parameters

      ec2 = create_ec2_connection(access_key_id, secret_access_key, endpoint_url, region) unless ec2

      nodes_size = ENV.fetch "nodes_size", "" 
      server_fqdn = ENV.fetch "server_fqdn", "" if server_fqdn == ""
      server_dns_name = ENV.fetch "server_dns_name", "" if server_dns_name == ""
      if nodes_size.strip == "" or server_fqdn.strip == "" or server_dns_name.strip == ""
        puts <<EOF
Please specify nodes_size, server_fqdn and server_dns_name such as the following example.
  rake dodai:ec2:nodes nodes_size=1 server_fqdn=ubuntu server_dns_name=ubuntu
where ether dns name or ip address is ok for server_dns_name.
EOF
        break
      end

      path = ENV.fetch "dodai_setup_node_script_file", "dodai_setup_node.sh.erb"
      path = "dodai_setup_node.sh.erb" if path == ""
      user_data = get_erb_template_from_file_content(path).result(binding)
      result = ec2.run_instances image_id, nodes_size, nodes_size, [security_group], key_pair, user_data, nil, instance_type
      instance_ids = result.collect{|i| i[:aws_instance_id]}
      puts "Wait until states of all the instances become running"
      loop do
        result = ec2.describe_instances instance_ids
        puts "The states of instances are as follows."
        instance_ids.each_index{|index| puts "  instance[#{instance_ids[index]}]: #{result[index][:aws_state]}"}
        if result.collect{|i| i[:aws_state]}.delete_if{|i| i == "running"}.empty?
          break
        end
        sleep 30
      end

      puts <<EOF
Nodes are started.
EOF

      result.each{|item|
        private_dns_name = convert_to_private_dns_name item[:private_dns_name]
        puts <<EOF
  instance id     : #{item[:aws_instance_id]}
  dns name        : #{item[:dns_name]}
  private dns name: #{private_dns_name}

EOF
      }

      node_private_dns_names = result.collect{|i| convert_to_private_dns_name i[:private_dns_name]}
    end

    task :start_server do
      break unless validate_parameters parameters

      ec2 = create_ec2_connection(access_key_id, secret_access_key, endpoint_url, region) unless ec2

      server_port = ENV.fetch "server_port", "3000"
      path = ENV.fetch "dodai_setup_server_script_file", "dodai_setup_server.sh.erb"
      path = "dodai_setup_server.sh.erb" if path == ""
      user_data = get_erb_template_from_file_content(path).result(binding)
      result = ec2.run_instances image_id, 1, 1, [security_group], key_pair, user_data, nil, instance_type
      instance_id = result[0][:aws_instance_id]
      puts "Wait until the instance[#{instance_id}]'s state become running."
      loop do
        result = ec2.describe_instances([instance_id])[0]
        puts "The instance[#{instance_id}]'s state is #{result[:aws_state]}."
        if result[:aws_state] == "running"
          break
        end
        sleep 30
      end

      private_dns_name = convert_to_private_dns_name result[:private_dns_name]
      puts <<EOF
Deploy server is started.
  instance id     : #{instance_id}
  dns name        : #{result[:dns_name]}
  private dns name: #{private_dns_name}
EOF

      server_dns_name = result[:dns_name]
      server_fqdn = private_dns_name
    end

    task :wait_nodes do
      break if server_dns_name == ""

      resource = RestClient::Resource.new("http://#{server_dns_name}:#{server_port}/nodes.json")
      begin
        node_private_dns_names.each{|private_dns_name|
          puts "Add node[#{private_dns_name}]"
          resource.post "node[name]=#{private_dns_name}"
        }
      rescue Exception => exc
        "Failed to add node."
         puts exc.inspect
         puts exc.backtrace
      end
    end

    task :wait_server do
      break if server_dns_name == ""
 
      puts "Wait until deploy server[#{server_dns_name}] is set up."
      timeout(1200) do
        loop do
          puts "Polling..."
          begin
            s = TCPSocket.open(server_dns_name, server_port.to_i)
            s.close
            break
          rescue
          end
          
          sleep 30
        end
      end

      puts "Deploy server[#{server_dns_name}] has been set up."
    end

    task :terminate do
      instance_id = ENV.fetch "instance", ""
      break if instance_id == ""

      ec2 = create_ec2_connection(access_key_id, secret_access_key, endpoint_url, region) unless ec2
      puts "Terminate instance[#{instance_id}]."
      ec2.terminate_instances [instance_id]
    end
  end
end
