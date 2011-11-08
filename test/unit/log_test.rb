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



class LogTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    proposal = Proposal.new(:name => 'test', :software => Software.find_by_name("nova"), :state => 'init')
    node = Node.new(:name => 'test', :ip => '0.0.0.0', :state => 'init')

    @log = Log.new(:content => 'log', :operation => 'install', :proposal => proposal, :node => node)
  end

  # called after every single test
  def teardown
  end

  test "should not save log without content" do
    @log.content = nil
    assert !@log.save
  end

  test "should not save log without operation" do
    @log.operation = nil
    assert !@log.save
  end

  test "should not save log without proposal" do
    @log.proposal = nil
    assert !@log.save
  end

  test "should not save log without node" do
    @log.node = nil
    assert !@log.save
  end

  test "should save log with correct operations" do
    operations = ["install", "uninstall", "test"]
    operations.each{|ope|
      @log.operation = ope
      assert @log.save
    }
  end

  test "should save log" do
    assert @log.save
  end

end

