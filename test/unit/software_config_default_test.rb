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

class SoftwareConfigDefaultTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    @scd = SoftwareConfigDefault.new(:path => Dir.pwd, :content => 'contents', :software => Software.find_by_name("nova"))
  end

  # called after every single test
  def teardown
  end

  test "should not save SoftwareConfigDefault without path" do
    @scd.path = nil
    assert !@scd.save
  end

  test "should not save SoftwareConfigDefault without content" do
    @scd.content = nil
    assert !@scd.save
  end

  test "should not save SoftwareConfigDefault without software" do
    @scd.software = nil
    assert !@scd.save
  end

  test "should not save SoftwareConfigDefault with the same path and software_id" do
    @scd.save
    scd_new = SoftwareConfigDefault.new(:path => Dir.pwd, :content => 'contents', :software => Software.find_by_name("nova"))
    assert !scd_new.save
  end

  test "should save SoftwareConfigDefault" do
    assert @scd.save
  end

end

