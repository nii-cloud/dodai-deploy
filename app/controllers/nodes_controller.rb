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
    @nodes = Node.find_all_by_user_id current_user.id

    respond_to do |format|
      format.html
      format.json { render :json => JSON.pretty_generate(@nodes.as_json) }
    end 
  end

  def new
    @node = Node.new
    @node_candidates = self._get_new_node_candidates
    logger.debug @node_candidates
  end

  def create
    @node = Node.new(params[:node])
    @node.state = "available"
    @node.user_id = current_user.id
    if @node.save
      respond_to do |format|
        format.html { redirect_to nodes_url }
        format.json  { render :json => JSON.pretty_generate(@node.as_json), :status => :created, :location => @node }
      end
    else
      respond_to do |format|
        format.html {
          @node_candidates = self._get_new_node_candidates
          render :action => "new"
        }
        format.json { render :json => JSON.pretty_generate({:errors => @node.errors}.as_json) }
      end
    end
  end

  def update
    @node = Node.find(params[:id])
    if @node.update_attributes(params[:node])
      respond_to do |format|
        format.json { render :json => JSON.pretty_generate(@node.as_json) }
      end
    else
      respond_to do |format|
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
      `puppetca --clean #{@node.name}`
      respond_to do |format|
        format.html { redirect_to(nodes_url) }
        format.json { render :json => "".as_json }
      end
    end
  end

  def _get_new_node_candidates
    ips = Node.find_all_by_user_id(current_user.id).map(&:ip)
    logger.debug ips
    McUtils.find_hosts(current_user.authentication_token).select{|node_candidate|
      logger.debug node_candidate
      not ips.include? node_candidate[:ip]
    }
  end
end
