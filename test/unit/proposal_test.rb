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

class ProposalTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    @proposal = Proposal.new(:name => 'test', :software => Software.find_by_name("nova"), :state => 'init')
  end

  # called after every single test
  def teardown
  end

  test "should not save proposal without name" do
    @proposal.name = nil 
    assert !@proposal.save
  end

  test "should not save proposal without software" do
    @proposal.software = nil
    assert !@proposal.save
  end

  test "should not save proposal without state" do
    @proposal.state = nil
    assert !@proposal.save
  end

  test "should not save proposal with the same name" do
    @proposal.save
    prop_new = Proposal.new(:name => 'test', :software => Software.find_by_name("nova"), :state => 'init')
    assert !prop_new.save
  end

  test "should save proposal with correct states" do
    states = ["init", "installed", "tested", "installed", "test failed", "waiting", "installing", 
               "uninstalling",  "testing"]
    states.each{|st|
      @proposal.state = st
      assert @proposal.save
    }
  end

  test "should save proposal" do
    assert @proposal.save
  end

end
