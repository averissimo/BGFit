require 'spec_helper'

include Warden::Test::Helpers

feature "Experiment" do
  
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  
  given(:model) { create(:model, owner: user) }
  
  background do
    Warden.test_mode!
  end
  
  given(:experiment) { build(:experiment, model: model) }
  
  scenario "Can Create new experiment" do
    Warden.test_reset! 
    login_as(user, :scope => :user)
    visit new_model_experiment_path(model)
    fill_in 'Title', :with => experiment.title
    fill_in 'Description', :with => experiment.description
    click_button 'Create Experiment'
    visit model_path(model)
    expect(page).to have_content experiment.title
  end
  
  scenario "Cannot create experiment with unauthorized user" do
    Warden.test_reset! 
    login_as(second_user, :scope => :user)
    visit new_model_experiment_path(model)
    expect(page).to have_content  "You are not authorized to access this page"
  end
  
  scenario "Cannot create experiment with user in team that only has read permissions" do
    Warden.test_reset! 
    # build conditions
    g = build(:group, users: [second_user,user])
    a = create(:accessible_read, group: g, permitable: model)
    
    login_as(second_user, :scope => :user)
    visit new_model_experiment_path(model)
    expect(page).to have_content  "You are not authorized to access this page"
  end
  
  scenario "Can create experiment with user in team that has write permissions" do
    Warden.test_reset! 
    # build conditions
    g = build(:group, users: [second_user,user])
    a = create(:accessible, group: g, permitable: model)
    login_as(second_user, :scope => :user)
    #
    visit new_model_experiment_path(model)
    fill_in 'Title', :with => experiment.title
    fill_in 'Description', :with => experiment.description
    click_button 'Create Experiment'
    visit model_path(model)
    expect(page).to have_content experiment.title
  end
  
  given(:experiment_saved) { create(:experiment, model: model) }
  
  scenario "Can goto experiment with user in team that only has read permissions" do
    Warden.test_reset! 
    # build conditions
    experiment.save
    g = build(:group, users: [second_user,user])
    a = create(:accessible_read, group: g, permitable: model)
    login_as(second_user, :scope => :user)
    #
    visit model_experiment_path(model,experiment)
    expect(page).to have_content experiment.title
  end
  
  scenario "Can goto experiment with user in team that only has write permissions" do
    Warden.test_reset! 
    # build conditions
    experiment.save
    g = build(:group, users: [second_user,user])
    a = create(:accessible, group: g, permitable: model)
    login_as(second_user, :scope => :user)
    #
    visit model_experiment_path(model,experiment)
    expect(page).to have_content experiment.title
  end

  
end
