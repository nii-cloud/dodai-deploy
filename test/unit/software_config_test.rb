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

class SoftwareConfigTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    proposal = Proposal.new(:name => 'test', :software => Software.find_by_name("nova"), :state => 'init')
    scd = SoftwareConfigDefault.new(:path => Dir.pwd, :content => 'contents', :software => Software.find_by_name("nova"))
    @sc = SoftwareConfig.new(:software_config_default => scd, :software => Software.find_by_name("nova"), :proposal => proposal, :content => 'contents') 
  end

  # called after every single test
  def teardown
  end

  test "should not save SoftwareConfig without software_config_default" do
    @sc.software_config_default = nil
    assert !@sc.save
  end

  test "should not save SoftwareConfig without software" do
    @sc.software = nil
    assert !@sc.save
  end

  test "should not save SoftwareConfig without content" do
    @sc.content = nil
    assert !@sc.save
  end

  test "should save SoftwareConfig" do
    assert @sc.save
  end

end
