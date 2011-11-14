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
  task :start_ec2 do
    access_key = ""
    secret_key = ""
    region = "ap-northeast-1"
    image_id = "ami-fa9723fb"
    
    nodes_size = ENV["nodes_size"]
    keypair = "guan_home"
    user_data = <<EOF
#!/bin/bash
apt-get install git -y
git clone https://github.com/nii-cloud/dodai-deploy

/dodai-deploy/setup-env/setup.sh server
/dodai-deploy/script/start-servers
EOF
    instance_type = "m1.large"

    ec2 = Aws::Ec2.new access_key, secret_key, :region => region
    result = ec2.run_instances image_id, 1, 1, ['default'], keypair, user_data, nil, instance_type 
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
    user_data = <<EOF
#!/bin/bash
apt-get install git -y
git clone https://github.com/nii-cloud/dodai-deploy

/dodai-deploy/setup-env/setup.sh node #{server_fqdn} 
EOF

    result = ec2.run_instances image_id, nodes_size, nodes_size, ['default'], keypair, user_data, nil, instance_type
    p result
  end
end
