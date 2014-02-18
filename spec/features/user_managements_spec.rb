require 'spec_helper'

feature "Signing in" do
    
  background do
    create(:user, :email => "user@example.com", :password => "caplin")
  end

  scenario "Signing in with correct credentials" do
    visit new_user_session_path
    fill_in 'Email', :with => 'user@example.com'
    fill_in 'Password', :with => 'caplin'
    click_button 'Login'
    expect(page).to have_content 'success'
  end

  given(:other_user) { build(:user) }

  scenario "Signing in as another user with incorrect credentials" do
    visit new_user_session_path
    fill_in 'Email', :with => other_user.email
    fill_in 'Password', :with => other_user.password
    click_button 'Login'
    expect(page).to have_content 'Invalid email or password'
  end

end

feature "Register user" do
  
  given(:new_user) { build(:user) }
  
  scenario "Registering a new user with all required fields" do
    visit new_user_registration_path
    fill_in 'Email', :with => new_user.email
    within("li#user_password_input") do
      fill_in 'Password', :with => new_user.password
    end
    fill_in 'Password confirmation', :with => new_user.password
    click_button 'Create User'
    expect(page).to have_content 'successfully'
  end
  
  given(:registered_user) { create(:user) }
  
  scenario "Registering an existing user" do
    visit new_user_registration_path
    fill_in 'Email', :with => registered_user.email
    within("li#user_password_input") do
      fill_in 'Password', :with => 'notimportant'
    end
    fill_in 'Password confirmation', :with => 'notimportant'
    click_button 'Create User'
    expect(page).to have_content 'Email has already been taken'
  end
  
  scenario "Registering a new user with different passwords" do
    visit new_user_registration_path
    fill_in 'Email', :with => new_user.email
    within("li#user_password_input") do
      fill_in 'Password', :with => new_user.password
    end
    fill_in 'Password confirmation', :with => new_user.password + " different"
    click_button 'Create User'
    expect(page).to have_content 'doesn\'t match'
  end
  
end