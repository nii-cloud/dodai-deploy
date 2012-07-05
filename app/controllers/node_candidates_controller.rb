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
class NodeCandidatesController < ApplicationController
  def index
    respond_to do |format| 
      format.json {
        ips = Node.find_all_by_user_id(current_user.id).map(&:ip)
        candidates = McUtils.find_hosts(current_user.authentication_token).select{|node_candidate|
          not ips.include? node_candidate[:ip]
        }
        render :json => JSON.pretty_generate(candidates.as_json)
      }
    end
  end
end
