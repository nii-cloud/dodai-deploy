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

class McUtils
  def self.find_hosts
    return ["localhost"]
  end
end

class IPSocket
  def self.getaddress(name)
    "10.0.0.1"
  end
end

class NodesControllerTest < ActionController::TestCase
  # called before every single test
  def setup
    @node = Node.new(:name => 'test', :ip => '0.0.0.0', :state => 'available')
    @node.save
  end

  # called after every single test
  def teardown
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:nodes)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:node)
    assert_not_nil assigns(:names)
    assert_template :new
  end

  test "should create node" do
    assert_difference("Node.count") do
      post :create, :node => {:name => "ubuntu4"}
    end
    assert_redirected_to nodes_path
  end

  test "should get destroy" do
    assert_not_nil Node.find(@node.id)
    assert_difference("Node.count", -1) do
      delete :destroy, :format => :json, :id => @node.id
    end 
    assert_response :success
  end

end

