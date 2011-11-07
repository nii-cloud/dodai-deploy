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
class ComponentDependency < ActiveRecord::Base
  validates_presence_of :source_component, :dest_component, :software, :operation
  validates_uniqueness_of :source_component_id, :scope => [:software_id, :dest_component_id, :operation]

  belongs_to :source_component, :class_name => "Component", :foreign_key => "source_component_id"
  belongs_to :dest_component, :class_name => "Component", :foreign_key => "dest_component_id"
  belongs_to :software

  after_initialize :init

  def init
    self.operation ||= "install"
  end
end

