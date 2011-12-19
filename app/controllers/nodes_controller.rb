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
class NodesController < ApplicationController

  def index
    @nodes = Node.all

    respond_to do |format|
      format.html
      format.json { render :json => JSON.pretty_generate(@nodes.as_json) }
    end 

  end

  def new
    @node = Node.new
    @names = self._get_new_node_names
  end

  def create
    @node = Node.new(params[:node])
    @node.ip = IPSocket.getaddress(@node.name) if @node.name
    @node.state = "available"
    if @node.save
      respond_to do |format|
        format.html { redirect_to nodes_url }
        format.json  { render :json => JSON.pretty_generate(@node.as_json), :status => :created, :location => @node }
      end
    else
      respond_to do |format|
        format.html {
          @names = self._get_new_node_names
          render :action => "new"
        }
        format.json { render :json => JSON.pretty_generate({:errors => @node.errors}.as_json) }
      end
    end
  end

  def destroy
    @node = Node.find(params[:id])
    if @node.node_configs.find(:first)
      @_errorMsg = "Added proposals must be destroyed first."
      respond_to do |format|
        format.html { 
          flash[:_errorMsg] = @_errorMsg
          redirect_to (nodes_url)
        }
        format.json { render :json => JSON.pretty_generate({:errors => @_errorMsg}.as_json) }
      end
      return
    end 
    if @node.destroy
      respond_to do |format|
        format.html { redirect_to(nodes_url) }
        format.json { render :json => "".as_json }
      end
    end
  end

  def _get_new_node_names
    McUtils.find_hosts - Node.all.map(&:name)
  end
end

