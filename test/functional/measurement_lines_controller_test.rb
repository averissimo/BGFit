require 'test_helper'

class MeasurementLinesControllerTest < ActionController::TestCase
  setup do
    @measurement_line = measurement_lines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:measurement_lines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create measurement_line" do
    assert_difference('MeasurementLine.count') do
      post :create, measurement_line: @measurement_line.attributes
    end

    assert_redirected_to measurement_line_path(assigns(:measurement_line))
  end

  test "should show measurement_line" do
    get :show, id: @measurement_line.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @measurement_line.to_param
    assert_response :success
  end

  test "should update measurement_line" do
    put :update, id: @measurement_line.to_param, measurement_line: @measurement_line.attributes
    assert_redirected_to measurement_line_path(assigns(:measurement_line))
  end

  test "should destroy measurement_line" do
    assert_difference('MeasurementLine.count', -1) do
      delete :destroy, id: @measurement_line.to_param
    end

    assert_redirected_to measurement_lines_path
  end
end
