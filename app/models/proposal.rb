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
class Proposal < ActiveRecord::Base
  validates_presence_of :name, :software, :state
  validates_uniqueness_of :name
  validates_inclusion_of :state, :in => ["init", "installed", "tested", 
                                         "install failed", "uninstall failed", "test failed", 
                                         "installing", "uninstalling", "testing",
                                         "waiting"]

  belongs_to :software
  has_many :node_configs, :dependent => :destroy, :finder_sql =>
    proc { "select nc.* " +
    "from node_configs nc, components c " +
    "where nc.component_id = c.id and nc.proposal_id = #{id} " +
    "order by c.name " }
  accepts_nested_attributes_for :node_configs

  has_many :component_configs, :dependent => :destroy
  accepts_nested_attributes_for :component_configs

  has_many :software_configs, :dependent => :destroy
  accepts_nested_attributes_for :software_configs

  has_many :logs, :dependent => :destroy
  accepts_nested_attributes_for :logs

  has_many :config_items, :dependent => :destroy
  accepts_nested_attributes_for :config_items

  has_one :waiting_proposal, :dependent => :destroy

  def as_json(options = {})
    super(:include => {:software => {}, 
                       :node_configs => {:include => [:component, :node]},
                       :config_items => {:include => [:config_item_default]},
                       :component_configs => {:include => [:component_config_default, :component]},
                       :software_configs => {:include => [:software_config_default]}})
  end
end
