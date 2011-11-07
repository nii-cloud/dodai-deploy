require 'test_helper'

class ComponentsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "should get index" do
    xhr :post, :index
    assert_response :success
    assert_not_nil assigns(:components)
  end
end
