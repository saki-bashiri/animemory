require 'test_helper'

class AnimeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get animelist" do
    get :animelist
    assert_response :success
  end

end
