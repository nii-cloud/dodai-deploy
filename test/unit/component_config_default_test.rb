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

class ComponentConfigDefaultTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    @ccd = ComponentConfigDefault.new(:path => Dir.pwd, :content => 'contents', :component => Component.find_by_name("ubuntu"))
  end

  # called after every single test
  def teardown
    @ccd = nil
  end

  test "should not save ComponentConfigDefault without path" do
    @ccd.path = nil
    assert !@ccd.save
  end

  test "should not save ComponentConfigDefault without content" do
    @ccd.content = nil
    assert !@ccd.save
  end

  test "should not save ComponentConfigDefault without component" do
    @ccd.component = nil
    assert !@ccd.save
  end

  test "should be success saved ComponentConfigDefault" do
    assert @ccd.save
  end

end

