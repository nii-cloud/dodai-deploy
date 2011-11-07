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
class Software < ActiveRecord::Base
  validates_uniqueness_of :name, :desc
  validates_presence_of :name, :desc

  has_many :components
  accepts_nested_attributes_for :components

  has_many :config_item_defaults
  accepts_nested_attributes_for :config_item_defaults

  has_many :software_config_defaults
  accepts_nested_attributes_for :software_config_defaults

  has_many :component_dependencies
  accepts_nested_attributes_for :component_dependencies

  has_one :test_component
  accepts_nested_attributes_for :test_component

  def as_json(options = {})
    super(:include => {:components => {:include => [:component_config_defaults]},
                        :config_item_defaults => {}, 
                        :software_config_defaults => {}})
  end
end
