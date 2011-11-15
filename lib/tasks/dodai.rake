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



  desc 'Set up ec2 instance'
  task :ec2 do

    p __FILE__
    p File.dirname __FILE__
    parameters = [ 
      ["ec2_access_key_id", "EC2 access key id"],
      ["ec2_secret_access_key", "EC2 access key"],
      ["ec2_key_pair", "EC2 key pair"],
      ["ec2_security_group", "EC2 security group"],
      ["ec2_image_id", "EC2 image id. It should be the image id of ubuntu 10.10, 11.04 or 11.10."],
      ["ec2_region", "EC2 region"],
      ["ec2_instance_type", "EC2 instance type. It should the type which can be used for the image specified in image_id."],
      ["dodai_nodes_size", "The size of nodes which will be set up."]
    ]

    parameters_str = parameters.collect{|parameter| "#{parameter[0]}: #{parameter[1]}"}.join("\n    ")
    if (parameters.collect{|parameter| parameter[0]} - ENV.keys).size > 0
      puts <<EOF
Usage:

  rake dodai:ec2

  The following variables should be defined in environment.
    #{parameters_str}

    ec2_endpoint_url is optional.
  Please refer to lib/tasks/dodai_ec2rc for values.
EOF
      break
    end

    access_key_id = ENV["ec2_access_key_id"] 
    secret_access_key = ENV["ec2_secret_access_key"]
    region = ENV["ec2_region"] 
    image_id = ENV["ec2_image_id"]
    key_pair = ENV["ec2_key_pair"]
    security_group = ENV["ec2_security_group"]
    instance_type = ENV["ec2_instance_type"]
    nodes_size = ENV["dodai_nodes_size"]
    endpoint_url = ENV.fetch "ec2_endpoint_url", nil
    user_data = get_erb_template_from_file_content("dodai_setup_server.sh.erb").result(binding)
    puts user_data

    if endpoint_url
      ec2 = Aws::Ec2.new access_key_id, secret_access_key, :endpoint_url => endpoint_url
    else
      ec2 = Aws::Ec2.new access_key_id, secret_access_key, :region => region
    end
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
    user_data = get_erb_template_from_file_content("dodai_setup_node.sh.erb").result(binding)
    puts user_data

    result = ec2.run_instances image_id, nodes_size, nodes_size, [security_group], key_pair, user_data, nil, instance_type
    p result
  end
end

def get_erb_template_from_file_content(file_name)
  file = open File.dirname(__FILE__) + "/#{file_name}"
  template = ERB.new file.read
  file.close

  template
end
