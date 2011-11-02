class WaitingProposalsController < ApplicationController
  def index
    @waiting_proposals = WaitingProposal.all
  end
end
