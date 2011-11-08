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

class TestComponentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    @tc = TestComponent.new(:software => Software.find_by_name("nova"), :component => Component.find_by_name("nova_compute"))
  end

  # called after every single test
  def teardown
  end

  test "should not save TestComponent without software" do
    @tc.software = nil
    assert !@tc.save
  end

  test "should not save TestComponent without component" do
    @tc.component = nil
    assert !@tc.save
  end

  test "should not save TestComponent duplicated unique keys" do
    @tc.save
    ltc = TestComponent.new(:software => Software.find_by_name("nova"), :component => Component.find_by_name("nova_compute"))
    assert !ltc.save
  end

  test "should be success saved TestComponent duplicated software_id" do
    @tc.save
    ltc = TestComponent.new(:software => Software.find_by_name("nova"), :component => Component.find_by_name("nova_network"))
    assert ltc.save
  end

  test "should be success saved TestComponent duplicated component_id" do
    @tc.save
    ltc = TestComponent.new(:software => Software.find_by_name("glance"), :component => Component.find_by_name("nova_compute"))
    assert ltc.save
  end

  test "should be success saved TestComponent" do
    assert @tc.save
  end

end
