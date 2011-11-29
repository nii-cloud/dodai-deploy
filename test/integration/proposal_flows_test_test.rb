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

class IPSocket
  def self.getaddress(name)
    "10.0.0.1"
  end
end

class ProposalFlowsTestTest < ActionDispatch::IntegrationTest
  fixtures :all

  def setup
    #create node "some node"
    @node_name = "some node"
    post "/nodes.json", :node => {:name => @node_name}
  end

  def teardown
    #delete node "some node"
    node = Node.find_by_name @node_name
    delete "/nodes/#{node.id}.json"
  end

  # Replace this with your real tests.
  test "create and install and uninstall and destroy nova" do
    software_name = "nova"

    #create proposal
    node = Node.find_by_name @node_name 
    software = Software.find_by_name software_name 
    node_configs = {}
    software.components.each_with_index do |component, index|
      node_configs[index.to_s] = {:component_name => component.name, :node_name => node.name}
    end

    software_config_default = software.software_config_defaults[0]

    software_configs = {}
    software_configs["0"] = {:path => software_config_default.path, :content => software_config_default.content} 

    proposal_name = "nova-test"
    proposal = {}
    proposal[:name] = proposal_name
    proposal[:software_desc] = software.desc
    proposal[:node_configs_attributes] = node_configs
    proposal[:software_configs_attributes] = software_configs 

    post "/proposals.json", :proposal => proposal

    assert_equal 201, @response.status
    proposal_hash = JSON.parse(@response.body)["proposal"]
    assert_equal proposal_name, proposal_hash["name"] 

    #install
    proposal = Proposal.find_by_name proposal_name 
    get "/proposals/#{proposal.id}/install.json"

    assert_equal 200, @response.status
    assert_equal "", @response.body.strip

    _wait_until_state_equal proposal.id, "installed"

    #uninstall
    get "/proposals/#{proposal.id}/uninstall.json"

    assert_equal 200, @response.status
    assert_equal "", @response.body.strip

    _wait_until_state_equal proposal.id, "init"

    #destroy
    delete "/proposals/#{proposal.id}.json"

    assert_equal 200, @response.status
    assert_equal "", @response.body.strip
  end

  def _wait_until_state_equal(proposal_id, state)
    timeout(60) {
      loop do
        get "/proposals/#{proposal_id}.json"
        proposal_hash = JSON.parse(@response.body)["proposal"]
        break if state == proposal_hash["state"]
        sleep 10
      end
    }
  end
end

