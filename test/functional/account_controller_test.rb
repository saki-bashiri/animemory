require 'test_helper'

class AccountControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get login_entry" do
    get :login_entry
    assert_response :success
  end

  test "should get login_end" do
    get :login_end
    assert_response :success
  end

end
