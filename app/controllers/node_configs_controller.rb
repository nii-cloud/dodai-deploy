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
class NodeConfigsController < ApplicationController
  def index
    if params.has_key? :node_id
      @node_configs = Node.find(params[:node_id]).node_configs
    else
      @node_configs = NodeConfig.all
    end
  end

  def puppet
    proposal_id = params[:proposal_id]
    proposal = Proposal.find proposal_id
    node = Node.find_by_name params[:node_name]
    if params[:operation] == "install" or params[:operation] == "uninstall"
      @node_configs = Scheduler.current proposal, params[:operation] 
    else
      test_component_id = proposal.software.test_component.component_id
      @node_configs = []
      proposal.node_configs.each do |node_config|
        if test_component_id == node_config.component_id
          @node_configs << node_config
          break
        end
      end
    end

    respond_to do |format|
      format.json do 
        output = {:classes => [], :parameters => {}}

        output[:classes] << proposal.software.name
        @node_configs.each do |node_config|
          output[:classes] << "#{proposal.software.name}::#{node_config.component.name}::#{params[:operation]}" if node_config.node_id == node.id
        end

        proposal.config_items.each do |config_item|
          output[:parameters][config_item.config_item_default.name] = config_item.value
        end

        proposal.node_configs.each do |node_config|
          output[:parameters][node_config.component.name] = [] unless output[:parameters].has_key? node_config.component.name
          output[:parameters][node_config.component.name] << IPSocket.getaddress(node_config.node.name)

          output[:parameters][node_config.component.name + "_fqdn"] = [] unless output[:parameters].has_key?(node_config.component.name + "_fqdn")
          output[:parameters][node_config.component.name + "_fqdn"] << node_config.node.name
        end

        output[:parameters]["proposal_id"] = proposal_id

        logger.debug output.to_yaml

        render :json => output      
      end
    end
  end

end

