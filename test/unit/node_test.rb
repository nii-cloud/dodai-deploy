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

class NodeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    @node = Node.new(:name => 'test', :ip => '0.0.0.0', :state => 'available')
  end

  # called after every single test
  def teardown
  end

  test "should not save node without name" do
    @node.name = nil
    assert !@node.save
  end

  test "should not save node without ip" do
    @node.ip = nil
    assert !@node.save
  end

  test "should not save node with incorrect state" do
    @node.state = 'enable'
    assert !@node.save
  end

  test "should not save node with the same name" do
    @node.save
    node_new = Node.new(:name => 'test', :ip => '0.0.0.1', :state => 'available')
    assert !node_new.save
  end

  test "should not save node with the same ip" do
    @node.save
    lnode = Node.new(:name => 'test2', :ip => '0.0.0.0', :state => 'available')
    assert !lnode.save
  end

  test "should save node" do
    assert @node.save
  end

end
