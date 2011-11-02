class WaitingJobsController < ApplicationController
  def index
    @waiting_jobs = WaitingJob.all
  end
end
