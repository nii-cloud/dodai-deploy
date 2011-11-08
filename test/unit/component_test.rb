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
require 'test_helper'

class ComponentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    @component = Component.new(:name => 'test', :software => Software.find_by_name("nova"))
  end

  # called after every single test
  def teardown
  end

  test "should not save component without name" do
    @component.name = nil
    assert !@component.save
  end

  test "should not save component without software" do
    @component.software = nil
    assert !@component.save
  end

  test "should not save component with the same name and software_id" do
    @component.save
    component_new = Component.new(:name => 'test', :software => Software.find_by_name("nova"))
    assert !component_new.save
  end

  test "should save component" do
    assert @component.save
  end

end
