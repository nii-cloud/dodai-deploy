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
class Operations
  def invoke(name, params)
    begin
      @proposal = Proposal.find params[:proposal_id]
      @proposal.state = "#{name}ing"
      @proposal.save

      waiting_proposal = WaitingProposal.find_by_proposal_id @proposal.id
      waiting_proposal.destroy 

      puts "Start #{name}[proposal - #{@proposal.id}]"

      result = self.method(name).call
    rescue => exc
      puts exc.inspect
      puts exc.backtrace      
      result = false
    ensure
      if result
        @proposal.state = "#{name}ed"
        @proposal.state = "init" if name == "uninstall"
      else
        @proposal.state = "#{name} failed"
      end
      @proposal.save

      Scheduler.delete @proposal if name == "install"

      puts "#{name}[proposal - #{@proposal.id}] finished"
    end
  end

  def install
    #write templates to puppet
    @proposal.software_configs.each do |software_config|
      path = software_config.software_config_default.path
      _save_template_to_puppet @proposal.id, path, software_config.content 
    end

    @proposal.component_configs.each do |component_config|
        path = component_config.component_config_default.path
        _save_template_to_puppet @proposal.id, path, component_config.content 
    end

    #save proposal id and operation to files
    _save_puppet_parameters({"proposal_id" => @proposal.id, "operation" => "install"})

    #install component one by one
    Scheduler.schedule @proposal

    success = true
    while Scheduler.next @proposal
      success = _operate_components(Scheduler.current(@proposal), @proposal.id)
      break unless success
    end

    success
  end

  def uninstall
    #save proposal id and operation to files
    _save_puppet_parameters({"proposal_id" => @proposal.id, "operation" => "uninstall"})

    #uninstall component one by one
    Scheduler.schedule @proposal, "uninstall"

    success = true
    while Scheduler.next @proposal, "uninstall"
      success = _operate_components(Scheduler.current(@proposal, "uninstall"), @proposal.id, "uninstall")
      break unless success
    end

    Utils.delete_template_from_puppet @proposal.id if success
    success
  end

  def test
    test_node_name = ""
    test_component_id = @proposal.software.test_component.component_id
    @proposal.node_configs.each do |node_config|
      if test_component_id == node_config.component_id
        test_node_name = node_config.node.name
        break
      end
    end

    _save_puppet_parameters({"proposal_id" => @proposal.id, "operation" => "test"})
    results = McUtils.puppetd_runonce [test_node_name]
    result = results[test_node_name]
    _save_puppet_message_to_log @proposal.id, Node.find_by_name(test_node_name).id, result[:message], "test"

    result[:status_code] == 0
  end

  private

  def _save_puppet_parameters parameters
    File.open(Settings.puppet.etc + "/parameters", "w") {|f| f.write parameters.to_yaml}
  end

  def _save_template_to_puppet(proposal_id, path, content)
    template_path = "#{Settings.puppet.etc}/templates/#{proposal_id.to_s}/#{path}.erb"
    dir_path = File.dirname template_path
    FileUtils.mkdir_p dir_path unless FileTest.directory? dir_path
    File.open(template_path, "w") {|f| f.write content}
  end

  def _save_puppet_message_to_log(proposal_id, node_id, content, operation)
    log = Log.new
    log.proposal_id = proposal_id
    log.node_id = node_id
    log.content = content
    log.operation = operation
    log.save
  end

  def _operate_components(node_configs, proposal_id, operation = "install")
    puts "#{operation} components"
    node_name_configs_map = {}
    node_configs.each{|node_config|
      node_name_configs_map[node_config.node.name] = [] unless node_name_configs_map.has_key? node_config.node.name
      node_name_configs_map[node_config.node.name] << node_config
    }

    results = McUtils.puppetd_runonce node_name_configs_map.keys

    success = true
    node_name_configs_map.each do |node_name, node_configs|
      result = results[node_name]
      _save_puppet_message_to_log proposal_id, Node.find_by_name(node_name).id, result[:message], operation

      node_configs.each do |node_config|
        if result[:status_code] == 0
          node_config.state = "#{operation}ed"
          node_config.state = "init" if operation == "uninstall"
        else
          node_config.state = "failed"
          success = false
        end

        node_config.save
      end
    end

    success
  end
end
