require 'test_helper'

class ArtistControllerTest < ActionController::TestCase
  test "should get top" do
    get :top
    assert_response :success
  end

  test "should get revision" do
    get :revision
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get edit_conf" do
    get :edit_conf
    assert_response :success
  end

end
