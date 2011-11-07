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

class SoftwareTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  # called before every single test
  def setup
    @software = Software.new(:name => 'test', :desc => 'desc')
  end

  # called after every single test
  def teardown
    @software = nil
  end

  test "should not save software without name" do
    @software.name = nil
    assert !@software.save
  end

  test "should not save software without desc" do
    @software.desc = nil
    assert !@software.save
  end

  test "should be success saved software" do
    assert @software.save
  end

end
