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

class NodeConfigsControllerTest < ActionController::TestCase
  # called before every single test
  def setup
    @node = Node.new(:name => 'test', :ip => '0.0.0.0', :state => 'init')
    @proposal = Proposal.new(:name => 'test', :software => Software.find_by_name("nova"), :state => 'init')
    @node.save
    @proposal.save
  end

  # called after every single test
  def teardown
  end

  test "should get index" do
    get :index, :id => @node.id
    assert_response :success
    assert_not_nil assigns(:node_configs)
    assert_template "index" 
  end

  test "should get index without param" do
    get :index
    assert_response :success
    assert_not_nil assigns(:node_configs)
    assert_template "index"
  end

  test "should get puppet" do
    get :puppet, :node_name => @node.name, :format => :json, :proposal_id => @proposal.id
    assert_response :success
    assert_not_nil assigns(:node_configs)
  end

end
