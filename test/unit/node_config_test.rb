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

class NodeConfigTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    proposal = Proposal.new(:name => 'test', :software => Software.find_by_name("nova"), :state => 'init')
    node = Node.new(:name => 'node', :ip => '0.0.0.0', :state => 'init')
    component = Component.new(:name => 'component', :software => Software.find_by_name("nova"))

    @nc = NodeConfig.new(:proposal => proposal, :node => node, :component => component, :state => 'init')
  end

  # called after every single test
  def teardown
  end

  test "should not save NodeConfig without node" do
    @nc.node = nil
    assert !@nc.save
  end

  test "should not save NodeConfig without component" do
    @nc.component = nil
    assert !@nc.save
  end

  test "should not save NodeConfig without state" do
    @nc.state = nil
    assert !@nc.save
  end

  test "should save NodeConfig with correct operations" do
    states = ["init", "installed", "failed"]
    states.each{|st|
      @nc.state = st
      assert @nc.save
    }
  end

  test "should save NodeConfig" do
    assert @nc.save
  end

end
