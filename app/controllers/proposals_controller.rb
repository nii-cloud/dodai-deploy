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
class ProposalsController < ApplicationController


  def index
    @proposals = Proposal.all

    respond_to do |format|
      format.html
      format.json { render :json => JSON.pretty_generate(@proposals.as_json) }
    end
  end

  def new
    @proposal = Proposal.new
    if !params.has_key? :software
      @proposal.software = Software.all[0]
    else
      @proposal.software = Software.find params[:software]
    end

    @proposal.software.config_item_defaults.each do |config_item_default|
      config_item = ConfigItem.new
      config_item.config_item_default = config_item_default
      config_item.value = config_item_default.value
      @proposal.config_items << config_item
    end

    @proposal.software.components.all.each do |component|
      node_config = NodeConfig.new
      node_config.component = component
      node_config.state = "init"
      @proposal.node_configs << node_config

      component.component_config_defaults.each do |component_config_default|
        component_config = ComponentConfig.new
        component_config.component = component
        component_config.component_config_default = component_config_default
        component_config.content = component_config_default.content
        @proposal.component_configs << component_config
      end
    end

    logger.debug @proposal.component_configs

    @proposal.software.software_config_defaults.each do |software_config_default|
      software_config = SoftwareConfig.new
      software_config.software = @proposal.software
      software_config.software_config_default = software_config_default 
      software_config.content = software_config_default.content
      @proposal.software_configs << software_config 
    end

    @os = @proposal.software.os
  end

  def create
    if params[:format] == "json"
      _change_params
    end

    _strip_contents_in_params
    @proposal = Proposal.new(params[:proposal])
    @proposal.state = "init" 
    if @proposal.save
      respond_to do |format|
        format.html { redirect_to(proposals_url) }
        format.json { render :json => JSON.pretty_generate(@proposal.as_json), :status => :created, :location => @proposal }
      end 
    else
      respond_to do |format|
        format.html { render :action => "new" }
        format.json { render :json => {:errors => @proposal.errors}.as_json }
      end
    end
  end

  def show
    @proposal = Proposal.find(params[:id]) 

     respond_to do |format|
      format.html
      format.json { render :json => JSON.pretty_generate(@proposal.as_json) }
     end
  end

  def edit
    @proposal = Proposal.find(params[:id])
    @os = @proposal.software.os
  end

  def update
    if params[:format] == "json"
      _change_params
    end

    params[:proposal].delete "software_id"

    @proposal = Proposal.find(params[:id])
    node_config_ids = @proposal.node_configs.collect {|node_config| node_config.id}
    new_node_config_ids = params[:proposal][:node_configs_attributes].values.collect {|value| value["id"].to_i}

    node_config_ids.each do |node_config_id|
      NodeConfig.find(node_config_id).destroy unless new_node_config_ids.include?(node_config_id)
    end    

    _strip_contents_in_params

    if @proposal.update_attributes(params[:proposal])
      @proposal.state = "init"
      @proposal.save
      respond_to do |format|
        format.html { redirect_to(proposals_url) }
        format.json { render :json => JSON.pretty_generate(@proposal.as_json) }
      end
    else
      respond_to do |format|
        format.html { render :action => "new" }
        format.json { render :json => {:errors => @proposal.errors}.as_json }
      end
    end

  end

  def destroy
    @proposal = Proposal.find(params[:id])
    if ["installed", "tested", "test failed", "installing", "testing", "uninstalling", "waiting"].include?(@proposal.state)
      respond_to do |format|
        format.html { redirect_to(proposals_url) }
        format.json { render :json => {:errors => "installed proposal can't be destroyed"}.as_json }
      end
    else
      if @proposal.destroy
        Utils.delete_template_from_puppet params[:id]
        respond_to do |format|
          format.html { redirect_to(proposals_url) }
          format.json { render :json => "".as_json }
        end
      end
    end
  end

  def install 
    _process "install"
  end

  def uninstall
    _process "uninstall"
  end

  def test
    _process "test"
  end

  private

  def _change_params
    proposal_hash = params[:proposal]
    logger.debug params[:proposal].inspect

    if (proposal_hash.keys - ["name", "software_desc"]).empty?
      software = Software.find_by_desc(proposal_hash["software_desc"])
      proposal_hash["software_id"] = software.id
      proposal_hash.delete "software_desc"

      attributes = {}
      index = 0
      software.config_item_defaults.each{|default| 
        attributes[index] = {"config_item_default_id" => default.id, "value" => default.value}
        index += 1
      }
      proposal_hash["config_items_attributes"] = attributes

      attributes = {}
      index = 0
      node = Node.first
      software.components.each{|component| 
        attributes[index] = {"node_id" => node.id, "component_id" => component.id}
        index += 1
      }
      proposal_hash["node_configs_attributes"] = attributes

      attributes = {}
      index = 0
      software.components.each {|component|
        component.component_config_defaults.each {|default|
          attributes[index] = {"component_id" => component.id, "component_config_default_id" => default.id, "content" => default.content}
          index += 1
        }
      }
      proposal_hash["component_configs_attributes"] = attributes

      attributes = {}
      index = 0
      software.software_config_defaults.each {|default|
        attributes[index] = {"software_id" => software.id, "software_config_default_id" => default.id, "content" => default.content}
        index += 1
      }
      proposal_hash["software_configs_attributes"] = attributes
      return proposal_hash
    end

    if proposal_hash.has_key? "software_desc"
      proposal_hash["software_id"] = Software.find_by_desc(proposal_hash["software_desc"]).id
      proposal_hash.delete "software_desc"
    else
      proposal_hash["software_id"] = Proposal.find(params[:id]).software_id
    end

    proposal_hash.fetch("config_items_attributes", {}).each {|index, config_item|
      config_item["config_item_default_id"] = ConfigItemDefault.find_by_name(config_item["name"]).id
      config_item.delete "name"
    }

    proposal_hash.fetch("node_configs_attributes", []).each {|index, node_config|
      node_config["node_id"] = Node.find_by_name(node_config["node_name"]).id
      node_config.delete "node_name"

      node_config["component_id"] = Component.find_by_name(node_config["component_name"]).id
      node_config.delete "component_name"
    }

    proposal_hash.fetch("component_configs_attributes", []).each {|index, component_config|
      component_config["component_id"] = Component.find_by_name(component_config["component_name"]).id
      component_config.delete "component_name"

      component_config["component_config_default_id"] = ComponentConfigDefault.find_by_path(component_config["path"]).id
      component_config.delete "path"
    }

    proposal_hash.fetch("software_configs_attributes", []).each {|index, software_config|
      software_config["software_id"] = proposal_hash["software_id"]

      software_config["software_config_default_id"] = SoftwareConfigDefault.find_by_path(software_config["path"]).id
      software_config.delete "path"
    }

    logger.debug proposal_hash.inspect
  end

  def _process(operation)
    proposal_id = params[:id]

    @proposal = Proposal.find proposal_id
    @proposal.state = "waiting" unless @proposal.state =~ /ing$/
    @proposal.save

    waiting_proposal = WaitingProposal.new
    waiting_proposal.proposal = @proposal
    waiting_proposal.operation = operation
    waiting_proposal.save

    mq = MessageQueueClient.new
    mq.publish({:operation => operation, :params => {:proposal_id => proposal_id}})
    mq.close

    respond_to do |format|
      format.html { redirect_to(proposals_url) }
      format.json { render :json => "".as_json }
    end
  end

  def _strip_contents_in_params
    if params[:proposal].has_key? :software_configs_attributes
      params[:proposal][:software_configs_attributes].each do |key, software_config_attr|
        software_config_attr[:content].strip!
        software_config_attr[:content].gsub! "\r", ""
      end
    end

    if params[:proposal].has_key? :component_configs_attributes
      params[:proposal][:component_configs_attributes].each do |key, component_config_attr|
        component_config_attr[:content].strip!
        component_config_attr[:content].gsub! "\r", ""
      end
    end
  end
end
