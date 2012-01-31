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
class RestApisController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json {
        apis = [{
            :name => "software", 
            :actions => [{:name => "list"}, {:name => "show", :parameters => ["id"]}]
          }, {
            :name => "component", 
            :actions => [{:name => "list"}, {:name => "show", :parameters => ["id"]}]
          }, {
            :name => "node",
            :actions => [
              {:name => "list"}, 
              {:name => "create", :parameters => ["name"]}, 
              {:name => "destroy", :parameters => ["id"]},
              {:name => "update", :parameters => ["id", "ip"]},
            ]
          }, {
            :name => "node_candidate",
            :actions => [{:name => "list"}]
          }, {
            :name => "proposal",
            :actions => [
              {:name => "list"}, 
              {:name => "create", :parameters => ["name", "software_desc"]}, 
              {:name => "destroy", :parameters => ["id"]},
              {:name => "show", :parameters => ["id"]},
              {:name => "install", :parameters => ["id"]},
              {:name => "uninstall", :parameters => ["id"]},
              {:name => "test", :parameters => ["id"]}
            ]
          }, {
            :name => "log",
            :actions => [{:name => "list"}]
          }
        ]
        render :json => JSON.pretty_generate(apis.as_json) 
      }
    end 
  end
end
