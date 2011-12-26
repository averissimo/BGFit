require 'test_helper'

class ResultsControllerTest < ActionController::TestCase
  setup do
    @result = results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create result" do
    assert_difference('Result.count') do
      post :create, result: @result.attributes
    end

    assert_redirected_to result_path(assigns(:result))
  end

  test "should show result" do
    get :show, id: @result.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @result.to_param
    assert_response :success
  end

  test "should update result" do
    put :update, id: @result.to_param, result: @result.attributes
    assert_redirected_to result_path(assigns(:result))
  end

  test "should destroy result" do
    assert_difference('Result.count', -1) do
      delete :destroy, id: @result.to_param
    end

    assert_redirected_to results_path
  end
end
