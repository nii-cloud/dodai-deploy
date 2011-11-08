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

class ComponentConfigTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    proposal = Proposal.new(:name => 'test', :software => Software.find_by_name("nova"), :state => 'init')
    component = Component.find_by_name("nova_compute")
    ccd = ComponentConfigDefault.find_by_path("/etc/nova/nova-compute.conf")

    @cc = ComponentConfig.new(:proposal => proposal, :component => component, :component_config_default => ccd, :content => 'contents')
  end

  # called after every single test
  def teardown
  end

  test "should not save ComponentConfig without component" do
    @cc.component = nil
    assert !@cc.save
  end

  test "should not save ComponentConfig without component_config_default" do
    @cc.component_config_default = nil
    assert !@cc.save
  end

  test "should not save ComponentConfig without content" do
    @cc.content = nil
    assert !@cc.save
  end

  test "should save ComponentConfig" do
    assert @cc.save
  end

end
