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

class ConfigItemTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    cid = ConfigItemDefault.new(:software => Software.find_by_name("nova"), :name => 'test', :value => 'values')
    proposal = Proposal.new(:name => 'test', :software => Software.find_by_name("nova"), :state => 'init')

    @ci = ConfigItem.new(:config_item_default => cid, :proposal => proposal, :value => 'values')
  end

  # called after every single test
  def teardown
  end

  test "should not save ConfigItem without config_item_default" do
    @ci.config_item_default = nil
    assert !@ci.save
  end

  test "should not save ConfigItem without value" do
    @ci.value = nil
    assert !@ci.save
  end

  test "should save ConfigItem" do
    assert @ci.save
  end

end
