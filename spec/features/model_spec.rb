require 'spec_helper'

include Warden::Test::Helpers

feature "Models" do

  background do
    Warden.test_mode!
  end

  given(:user) { create(:user) }
  given(:model) { build(:model) }

  scenario "Create new model" do
    Warden.test_reset!
    login_as(user, :scope => :user)
    visit new_model_path
    fill_in 'Title', :with => model.title
    fill_in 'Description', :with => model.description
    uncheck 'Published?'
    click_button 'Create Project'
    visit models_path
    expect(page).to have_content model.title
    visit public_models_path
    expect(page).not_to have_content model.title
  end

  given(:published_model) { build(:published_model) }

  scenario "Create new published model" do
    Warden.test_reset!
    login_as(user, :scope => :user)
    visit new_model_path
    fill_in 'Title', :with => published_model.title
    fill_in 'Description', :with => published_model.description
    check 'Published?'
    click_button 'Create Project'
    visit models_path
    expect(page).to have_content published_model.title
    visit public_models_path
    expect(page).to have_content published_model.title
  end

  scenario "Title is mandatory" do
    Warden.test_reset!
    login_as(user, :scope => :user)
    visit new_model_path
    fill_in 'Description', :with => published_model.description
    click_button 'Create Project'
    expect(page).to have_content "Title cannot be blank"
  end

  scenario "Cannot access other user's private model" do
    Warden.test_reset!
    login_as(user, :scope => :user)
    model.owner = create(:user) if model.owner_id == user.id
    model.save
    visit model_path(model)
    expect(page).not_to have_content model.title
  end

  given(:admin) { create(:admin) }

  scenario "Can access other person's user's private as admin" do
    Warden.test_reset!
    login_as(admin, :scope => :user)
    model.save
    visit model_path(model)
    expect(page).to have_content model.title
  end

end
