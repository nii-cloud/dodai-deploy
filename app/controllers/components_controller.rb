class ComponentsController < ApplicationController

  def index
    @components = Component.all

    respond_to do |format|
      format.json { render :json => JSON.pretty_generate(@components.as_json) }
    end
  end

  def show
    @component = Component.find params[:id]

    respond_to do |format|
      format.json { render :json => JSON.pretty_generate(@component.as_json) }
    end
  end
end
