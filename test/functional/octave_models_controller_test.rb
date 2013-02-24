require 'test_helper'

class OctaveModelsControllerTest < ActionController::TestCase
  setup do
    @octave_model = octave_models(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:octave_models)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create octave_model" do
    assert_difference('OctaveModel.count') do
      post :create, octave_model: { model: @octave_model.model, name: @octave_model.name }
    end

    assert_redirected_to octave_model_path(assigns(:octave_model))
  end

  test "should show octave_model" do
    get :show, id: @octave_model
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @octave_model
    assert_response :success
  end

  test "should update octave_model" do
    put :update, id: @octave_model, octave_model: { model: @octave_model.model, name: @octave_model.name }
    assert_redirected_to octave_model_path(assigns(:octave_model))
  end

  test "should destroy octave_model" do
    assert_difference('OctaveModel.count', -1) do
      delete :destroy, id: @octave_model
    end

    assert_redirected_to octave_models_path
  end
end
