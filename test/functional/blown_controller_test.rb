require 'test_helper'

class BlownControllerTest < ActionController::TestCase
  test "should get away" do
    get :away
    assert_response :success
  end

end
