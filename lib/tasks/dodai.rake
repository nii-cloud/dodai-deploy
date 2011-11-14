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

    if (["access_key_id", "secret_access_key", "nodes_size", "key_pair"] - ENV.keys).size > 0

      puts <<EOF
Usage:

  rake access_key_id=$ACCESS_KEY_ID secret_access_key=$SECRET_ACCESS_KEY nodes_size=$NODES_SIZE key_pair=$KEY_PAIR dodai:ec2

  $ACCESS_KEY_ID: EC2 aws access key id.
  $SECRET_ACCESS_KEY: EC2 aws secret access key.
  $NODES_SIZE: The size of nodes.
  $KEY_PAIR: key pair.
EOF

      break
    end

    access_key_id = ENV["access_key_id"] 
    secret_access_key = ENV["secret_access_key"]
    region = "ap-northeast-1"
    image_id = "ami-fa9723fb"
    
    nodes_size = ENV["nodes_size"]
    key_pair = ENV["key_pair"]
    user_data = <<EOF
#!/bin/bash
apt-get install git -y
git clone https://github.com/nii-cloud/dodai-deploy

sed -i -e '/127\.0\.1\.1/d' /etc/hosts

/dodai-deploy/setup-env/setup.sh server
/dodai-deploy/script/start-servers production
EOF
    instance_type = "m1.large"

    ec2 = Aws::Ec2.new access_key_id, secret_access_key, :region => region
    result = ec2.run_instances image_id, 1, 1, ['default'], key_pair, user_data, nil, instance_type 
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

sed -i -e '/127\.0\.1\.1/d' /etc/hosts

/dodai-deploy/setup-env/setup.sh node #{server_fqdn} 
/dodai-deploy/setup-env/setup-storage-for-swift.sh loopback /srv/node sdb1 4
EOF

    result = ec2.run_instances image_id, nodes_size, nodes_size, ['default'], key_pair, user_data, nil, instance_type
    p result
  end
end
