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

class IPSocket
  def self.getaddress(name)
    "10.0.0.1"
  end
end

class NodeFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all

  # Replace this with your real tests.
  test "add and destroy node" do
    node_name = "some node"
    
    #create node
    post "/nodes.json", :node => {:name => node_name}
    node = JSON.parse(@response.body)["node"]
    node = Struct.new("NodeStruct", *node.keys).new(*node.values)
    assert_equal 201, @response.status
    assert_equal node_name, node.name

    #delete node    
    delete "/nodes/#{node.id}.json"
    assert_equal "", @response.body.strip
    assert_equal 200, @response.status
  end
end

