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
require 'test_helper'

class MessageQueueClient
  def initialize
  end

  def subscribe
  end

  def publish(msg_obj)
    proposal_id = msg_obj[:params][:proposal_id]
    operation = msg_obj[:operation]

    proposal = Proposal.find proposal_id
    proposal.state = "#{operation}ed"
    proposal.state = "init" if operation == "uninstall"
    proposal.save
  end

  def unsubscribe
  end

  def close
  end
end

class ProposalsControllerTest < ActionController::TestCase
  # called before every single test
  def setup
    @software = Software.new(:name => 'Openstack Nova', :desc => 'desc')
    @proposal = Proposal.new(:name => 'TEST', :software => @software, :state => 'init')
    @node = Node.new(:name => 'Node1', :ip => '0.0.0.0', :state => 'available')
    @component = Component.find_by_name("nova_compute")
    @nc = NodeConfig.new(:proposal => @proposal, :node => @node, :component => @component, :state => 'init')
    @cid = ConfigItemDefault.new(:software => @software, :name => 'test', :value => 'values')
    @scd = SoftwareConfigDefault.new(:path => Dir.pwd, :content => 'contents', :software => @software)
    @sc = SoftwareConfig.new(:software_config_default => @scd, :software => Software.find_by_name("nova"), :proposal => @proposal, :content => 'contents')
    @ci = ConfigItem.new(:config_item_default => @cid, :proposal => @proposal, :value => 'values')

    @software.save
    @proposal.save
    @node.save
    @component.save
    @nc.save
    @cid.save
    @scd.save
    @sc.save
    @ci.save
  end

  # called after every single test
  def teardown
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proposals)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:proposal)
  end

  test "should create proposal" do
    software_name = "nova"
    node_name = "Node1"

    node = Node.find_by_name node_name
    software = Software.find_by_name software_name
    node_configs = {}
    software.components.each_with_index do |component, index|
      node_configs[index.to_s] = {:component_id => component.id, :node_id => node.id, :state => 'init'}
    end

    software_config_default = software.software_config_defaults[0]
    software_configs = {}
    software_configs["0"] = {:software_config_default_id => software_config_default.id,
                             :content => software_config_default.content,
                             :software_id => software.id}

    config_item = {}
    config_item["0"] = {:config_item_default_id => @cid.id, :value => 'localhost'}

    proposal_name = "nova-test"
    proposal = {}
    proposal[:name] = proposal_name
    proposal[:node_configs_attributes] = node_configs
    proposal[:software_configs_attributes] = software_configs
    proposal[:config_items_attributes] = config_item
    proposal[:software_id] = software.id

    assert_difference("Proposal.count") do
      post :create, :proposal => proposal
    end

    assert_redirected_to proposals_path
    assert_not_nil assigns(:proposal)

  end

  test "should not create proposal" do
    software_name = "nova"
    node_name = "Node1"

    node = Node.find_by_name node_name
    software = Software.find_by_name software_name
    node_configs = {}
    software.components.each_with_index do |component, index|
      node_configs[index.to_s] = {:component_id => component.id, :node_id => node.id, :state => 'incorrect'}
    end

    software_config_default = software.software_config_defaults[0]
    software_configs = {}
    software_configs["0"] = {:software_config_default_id => software_config_default.id,
                             :content => software_config_default.content,
                             :software_id => software.id}

    config_item = {}
    config_item["0"] = {:config_item_default_id => @cid.id, :value => 'localhost'}

    proposal_name = @proposal.name
    proposal = {}
    proposal[:name] = proposal_name
    proposal[:node_configs_attributes] = node_configs
    proposal[:software_configs_attributes] = software_configs
    proposal[:config_items_attributes] = config_item
    proposal[:software_id] = software.id

    post :create, :proposal => proposal
    assert_response :success

  end

  test "should get show" do
    get :show,
        :id => @proposal.id
    assert_response :success
    assert_not_nil assigns(:proposal)
    assert_template :show
  end

  test "should get edit" do
    get :edit,
        :id => @proposal.id
    assert_response :success
    assert_not_nil assigns(:proposal)
    assert_template :edit
  end

  test "should update proposal" do
    software_name = "nova"
    node_name = "Node1"
    new_proposal_name = "new_proposal"
    new_hostname = "new_host"
    new_content = "new_content"

    node = Node.find_by_name node_name 
    software = Software.find_by_name software_name 
    node_configs = {}
    software.components.each_with_index do |component, index|
      node_configs[index.to_s] = {:component_id => component.id, :id => @nc.id,
                                  :node => @node, :state => 'installed'}
    end

    node_configs[node_configs.size+1] = {:component_id => @component.id, :node => @node, :state => 'installed'}

    software_config_default = software.software_config_defaults[0]
    software_configs = {}
    software_configs["0"] = {:software_config_default_id => software_config_default.id,
                             :content => new_content, :id => @sc.id,
                             :software_id => software.id} 

    config_item = {}
    config_item["0"] = {:config_item_default_id => @cid.id, :id => @ci.id, :value => new_hostname}

    proposal = {}
    proposal[:name] = new_proposal_name
    proposal[:node_configs_attributes] = node_configs
    proposal[:software_configs_attributes] = software_configs 
    proposal[:config_items_attributes] = config_item

    assert_difference("NodeConfig.count") do
      put :update, :id => @proposal.id, :proposal => proposal
    end

    assert_equal new_proposal_name, Proposal.find(@proposal.id).name
    assert_equal new_hostname, ConfigItem.find(@ci.id).value
    assert_equal new_content, SoftwareConfig.find(@sc.id).content
    
  end

  test "should destroy proposal" do

    assert_difference("Proposal.count", -1) do
      delete :destroy, :id => @proposal.id
    end
    assert_redirected_to proposals_path

  end

  test "should get install" do

    get :install, :id => @proposal.id
    assert_redirected_to proposals_path
    assert_equal "installed", Proposal.find(@proposal.id).state

  end

  test "should get uninstall" do

    get :uninstall, :id => @proposal.id
    assert_redirected_to proposals_path
    assert_equal "init", Proposal.find(@proposal.id).state

  end

  test "should get test" do

    get :test, :id => @proposal.id
    assert_redirected_to proposals_path
    assert_equal "tested", Proposal.find(@proposal.id).state

  end

end
