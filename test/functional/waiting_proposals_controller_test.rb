require 'test_helper'

class WaitingProposalsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
