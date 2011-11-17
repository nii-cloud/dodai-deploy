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

  desc 'Equal to ec2:all'
  task :ec2 do
    Rake::Task["dodai:ec2:all"].invoke
  end

  namespace :ec2 do
    def get_erb_template_from_file_content(path)
      file = open path
      template = ERB.new file.read
      file.close
    
      template
    end

    parameters = [
      ["ec2_access_key_id", "EC2 access key id"],
      ["ec2_secret_access_key", "EC2 access key"],
      ["ec2_key_pair", "EC2 key pair"],
      ["ec2_security_group", "EC2 security group"],
      ["ec2_image_id", "EC2 image id. It should be the image id of ubuntu 10.10, 11.04 or 11.10."],
      ["ec2_region", "EC2 region"],
      ["ec2_instance_type", "EC2 instance type. It should the type which can be used for the image specified in image_id."],
    ]

    def validate_parameters
      parameters_str = parameters.collect{|parameter| "#{parameter[0]}: #{parameter[1]}"}.join("\n    ")
      result = (parameters.collect{|parameter| parameter[0]} - ENV.reject{|key, value| value.strip == ""}.keys).size == 0
      unless result
        puts <<EOF
Usage:

  rake dodai:ec2 | dodai:ec2:server | dodai:ec2:nodes | dadai:all

  The following variables should be defined in environment.
    #{parameters_str}

    ec2_endpoint_url is optional.
  Please refer to lib/tasks/dodai_ec2rc for values.
EOF

      end

      result
    end

    access_key_id = ENV["ec2_access_key_id"]
    secret_access_key = ENV["ec2_secret_access_key"]
    region = ENV["ec2_region"]
    image_id = ENV["ec2_image_id"]
    key_pair = ENV["ec2_key_pair"]
    security_group = ENV["ec2_security_group"]
    instance_type = ENV["ec2_instance_type"]
    endpoint_url = ENV.fetch "ec2_endpoint_url", "" 
    server_fqdn = "" 

    def create_ec2_connection
      if endpoint_url.strip != ""
        ec2 = Aws::Ec2.new access_key_id, secret_access_key, :endpoint_url => endpoint_url
      else
        ec2 = Aws::Ec2.new access_key_id, secret_access_key, :region => region
      end
    end


    desc 'Set up a dodai-deploy server and nodes on ec2'
    task :all do
      break unless validate_parameters

      if ENV.fetch("nodes_size", "") == ""
        puts <<EOF
Please use dodai:ec2 | dodai:ec2:all like the following example.
  rake nodes_size=1 dodai:ec2
EOF
        break
      end
      Rake::Task["dodai:ec2:server"].invoke
      Rake::Task["dodai:ec2:nodes"].invoke
    end

    desc 'Set up dodai-deploy nodes on ec2.'
    task :nodes do 
      break unless validate_parameters

      ec2 = create_ec2_connection

      nodes_size = ENV.fetch "nodes_size", "" 
      server_fqdn = ENV.fetch "server_fqdn", "" if server_fqdn == ""
      if nodes_size.strip == "" or server_fqdn.strip == ""
        puts <<EOF
Please use task dodai:ec2:nodes like the following example.
  rake nodes_size=1 server_fqdn=ubuntu dodai:ec2:nodes 
EOF
        break
      end

      path = ENV.fetch "dodai_setup_node_script_file", "dodai_setup_node.sh.erb"
      user_data = get_erb_template_from_file_content(path).result(binding)
      result = ec2.run_instances image_id, nodes_size, nodes_size, [security_group], key_pair, user_data, nil, instance_type
      p result
    end

    desc 'Set up a dodai-deploy server on ec2.'
    task :server do
      break unless validate_parameters

      ec2 = create_ec2_connection

      path = ENV.fetch "dodai_setup_server_script_file", "dodai_setup_server.sh.erb"
      path = File.dirname(__FILE__) + "/" + path if Pathname.new(path).relative?
      user_data = get_erb_template_from_file_content(path).result(binding)
      result = ec2.run_instances image_id, 1, 1, [security_group], key_pair, user_data, nil, instance_type
      instance_id = result[0][:aws_instance_id]
      loop do
        result = ec2.describe_instances [instance_id]
        p result
        if result[0][:aws_state] == "running"
          break
        end
        sleep 5
      end

      server_fqdn = result[0][:private_dns_name]
    end
  end
end
