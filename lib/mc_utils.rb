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
require "pty"

class McUtils
  def self.prepare_config_file(auth_token)
    config_file = open "#{Rails.root.to_s}/config/mc_client.cfg"
    content = config_file.read
    config_file.close

    file = Tempfile.new(auth_token)
    path = file.path
    begin
      file.puts(content.sub("TOKEN", auth_token))
    ensure
      file.close
    end

    return path
  end

  def self.create_and_exec_cmd(sub_cmd, auth_token)
    config_file_path = self.prepare_config_file auth_token
    cmd = "/usr/bin/mco #{sub_cmd} -c #{config_file_path} --dt #{Settings.mcollective.discovery_timeout} --json"
    puts cmd
    Rails.logger.debug cmd

    output = ""
    PTY.spawn(cmd) do |r, w|
      output = r.read
    end

    obj = []
    begin
      obj = JSON.parse(output)
    rescue
    end

    p obj
    Rails.logger.debug obj

    obj
  end

  def self.find_hosts(auth_token)
    output = self.create_and_exec_cmd "rpc rpcutil inventory", auth_token
    hosts = []
    output.each do |item|
      host = item["data"]["facts"]
      host["name"] = host["hostname"]
      host.delete "hostname"
      hosts << host 
    end

    hosts
  end

  def self.get_host_facts(node_name, auth_token)
    output = self.create_and_exec_cmd "rpc rpcutil inventory --wf 'hostname=~#{node_name}'", auth_token

    facts = {} 
    facts = output[0]["data"]["facts"] if output.size > 0
    facts
  end

  def self.puppetd_runonce(node_names, auth_token)
    output = ""
    node_names_str = node_names.join "|"
    output = self.create_and_exec_cmd "rpc puppetd runonce server=#{Settings.puppet.server} port=#{Settings.puppet.port} auth_token=#{auth_token} -t #{Settings.mcollective.timeout} --wf 'hostname=~" + node_names_str + "'", auth_token
 
    ret = {}
    output.each do |item|
      puts item.to_yaml

      status_code = item["statuscode"]
      if status_code == 0
        message = item["data"]["output"].gsub /\e[\[0-9;]+m/, ""
        status_code = 1 if /^E: / =~ message or /^err: / =~ message
      else
        message = item["statusmsg"]
      end

      name = item["sender"]
      ret[name] = {:status_code => status_code, :message => message}
    end

    node_names.each do |node_name|
      ret[node_name] = {:status_code => 1, :message => "We did not discover any nodes."} unless ret.has_key? node_name
    end 

    ret
  end
end
