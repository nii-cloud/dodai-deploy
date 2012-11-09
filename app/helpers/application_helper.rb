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
module ApplicationHelper

  def javascript_include_tag_if_exists(source)
    path = "#{config.javascripts_dir}#{File::SEPARATOR}#{source}.js"
    if File.exists? path
      javascript_include_tag source
    else
      ""
    end
  end

  SoftwareGroup = Struct.new("SoftwareGroup", :name, :softwares)
  def get_software_groups()
    software_groups = {}
    Software.all.sort{|a, b| a.desc <=> b.desc}.each {|software|
      software_groups[software.os] = SoftwareGroup.new(software.os, []) unless software_groups.has_key? software.os
      software_groups[software.os].softwares << software
    }
    software_groups.values
  end
end
