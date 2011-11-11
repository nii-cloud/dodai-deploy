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
class Scheduler

  def self.schedule(proposal, operation = "install")
    results = []

    filter_state = ""
    if operation == "install"
      filter_state = "installed"
    else operation == "uninstall"
      filter_state = "init"
    end

    node_configs = proposal.node_configs.reject{|node_config| node_config.state == filter_state}
    component_ids = node_configs.map(&:component_id).uniq

    dependency_map = {}
    proposal.software.component_dependencies.reject{|dependency| dependency.operation != operation}.each do |dependency|
      if component_ids.include? dependency.source_component.id and component_ids.include? dependency.dest_component.id 
        dependency_map[dependency.source_component.id] = [] unless dependency_map.has_key? dependency.source_component.id 
        dependency_map[dependency.source_component.id] << dependency.dest_component.id
      end
    end

    while node_configs.size > 0
      independent_node_configs = []
      node_configs.each do |node_config|
        independent_node_configs << node_config unless dependency_map.has_key? node_config.component.id
      end

      results << independent_node_configs
      node_configs = node_configs - independent_node_configs

      independent_component_ids = independent_node_configs.map(&:component_id)
      dependency_map.delete_if {|key, value| 
        value.delete_if {|id| independent_component_ids.include? id}
        value.size == 0 
      }

    end

    ScheduleCache.write proposal.id, operation,  [results, -1]
  end

  def self.current(proposal, operation = "install") 
    return nil unless ScheduleCache.exist? proposal.id, operation

    data = ScheduleCache.read proposal.id, operation
    schedule, position = data
    if position == -1 
      nil
    else
      schedule[position]
    end
  end

  def self.next(proposal, operation = "install")
    return nil unless ScheduleCache.exist? proposal.id, operation

    data = ScheduleCache.read proposal.id, operation
    schedule, position = data
    if position < schedule.size - 1
      position += 1

      ScheduleCache.write proposal.id, operation, [schedule, position]
      schedule[position]
    else
      nil
    end
  end

  def self.delete(proposal, operation = "install")
    ScheduleCache.delete proposal.id, operation
  end

end
