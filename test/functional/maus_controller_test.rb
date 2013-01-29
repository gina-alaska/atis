require 'test_helper'

class MausControllerTest < ActionController::TestCase
  setup do
    @mau = maus(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maus)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mau" do
    assert_difference('Mau.count') do
      post :create, mau: { name: @mau.name }
    end

    assert_redirected_to mau_path(assigns(:mau))
  end

  test "should show mau" do
    get :show, id: @mau
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mau
    assert_response :success
  end

  test "should update mau" do
    put :update, id: @mau, mau: { name: @mau.name }
    assert_redirected_to mau_path(assigns(:mau))
  end

  test "should destroy mau" do
    assert_difference('Mau.count', -1) do
      delete :destroy, id: @mau
    end

    assert_redirected_to maus_path
  end
end
