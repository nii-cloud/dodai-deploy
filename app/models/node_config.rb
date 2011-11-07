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
class NodeConfig < ActiveRecord::Base
  validates_presence_of :node, :component, :state
  validates_inclusion_of :state, :in => %w(init installed failed) 

  belongs_to :proposal
  belongs_to :node
  belongs_to :component

  after_initialize :init

  def init
    self.state ||= "init"
  end
end
