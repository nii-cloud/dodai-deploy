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
require "node"
require "node_config"
require "component"

class ScheduleCache
  def self.write(proposal_id, operation, data)
    Rails.cache.write self._get_key(proposal_id, operation), Marshal.dump(data)
  end

  def self.read(proposal_id, operation)
    Marshal.load Rails.cache.read self._get_key(proposal_id, operation)
  end

  def self.exist?(proposal_id, operation)
    Rails.cache.exist? self._get_key(proposal_id, operation)
  end

  def self.delete(proposal_id, operation)
    Rails.cache.delete self._get_key(proposal_id, operation)
  end 

  private

  def self._get_key(proposal_id, operation)
    "/schedules/#{proposal_id}_#{operation}"
  end
end
