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
    @wp = nil
  end

  test "should not save WaitingProposal without proposal" do
    @wp.proposal = nil
    assert !@wp.save
  end

  test "should not save WaitingProposal without operation" do
    @wp.operation = nil
    assert !@wp.save
  end

  test "should be success saved WaitingProposal" do
    assert @wp.save
  end

end
