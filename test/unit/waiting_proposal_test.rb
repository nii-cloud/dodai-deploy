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

class WaitingProposalTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    @proposal = Proposal.new(:name => 'test', :software => Software.find_by_name("nova"), :state => 'init')
    @wp = WaitingProposal.new(:proposal => @proposal, :operation => 'install')
  end

  # called after every single test
  def teardown
  end

  test "should not save WaitingProposal without proposal" do
    @wp.proposal = nil
    assert !@wp.save
  end

  test "should not save WaitingProposal without operation" do
    @wp.operation = nil
    assert !@wp.save
  end

  test "should not save WaitingProposal duplicated unique keys" do
    @wp.save
    lwp = WaitingProposal.new(:proposal => @proposal, :operation => 'install')
    assert !lwp.save
  end

  test "should be success saved WaitingProposal duplicate proposal_id" do
    @wp.save
    lwp = WaitingProposal.new(:proposal => @proposal, :operation => 'uninstall')
    assert lwp.save
  end

  test "should be success saved WaitingProposal duplicate operation" do
    @wp.save
    lproposal = Proposal.new(:name => 'test2', :software => Software.find_by_name("glance"), :state => 'init')
    lwp = WaitingProposal.new(:proposal => lproposal, :operation => 'uninstall')
    assert lwp.save
  end

  test "should be success saved WaitingProposal with correct operation" do
    operations = ['install', 'uninstall', 'test']
    operations.each{|ope|
      @wp.operation = ope
      assert @wp.save
    }
  end

  test "should be success saved WaitingProposal" do
    assert @wp.save
  end

end
