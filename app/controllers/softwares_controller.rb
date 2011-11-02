class SoftwaresController < ApplicationController
  def index
    @softwares = Software.all

    respond_to do |format|
      format.json { render :json => JSON.pretty_generate(@softwares.as_json) }
    end
  end

  def show
    @software = Software.find params[:id]

    respond_to do |format|
      format.json { render :json => JSON.pretty_generate(@software.as_json) }
    end
  end
end
