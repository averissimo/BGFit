require 'spec_helper'
require 'capybara/rails'

feature "Signing in" do
    background do
      u = User.new(:email => 'user@example.com', :password => 'caplin')
      u.save
    end

  scenario "Signing in with correct credentials" do
    visit new_user_session_path
    fill_in 'Email', :with => 'user@example.com'
    fill_in 'Password', :with => 'caplin'
    click_button 'Login'
    expect(page).to have_content 'success'
  end

  given(:other_user) { User.new(:email => 'other@example.com', :password => 'rous') }

  scenario "Signing in as another user with incorrect credentials" do
    visit new_user_session_path
    fill_in 'Email', :with => other_user.email
    fill_in 'Password', :with => other_user.password
    click_button 'Login'
    expect(page).to have_content 'Invalid email or password'
  end

end

feature "Register user" do
  
  given(:registered_user) { User.new(:email => 'user@example.com', :password => 'caplin') }
  
  background do
      u = User.new(:email => registered_user.email, :password => registered_user.password)
      u.save
  end
  
  scenario "Registering an existing user" do
    visit new_user_registration_path
    fill_in 'Email', :with => registered_user.email
    fill_in 'Password', :with => 'different password'
    fill_in 'Password confirmation', :with => 'different password'
    click_button 'Login'
    expect(page).to have_content 'The email has already been registered.'
  end
  
  given(:new_user) { User.new(:email => 'new@example.com', :password => 'rous') }
  
  scenario "Registering a new user with all required fields" do
    visit new_user_registration_path
    fill_in 'Email', :with => new_user.email
    fill_in 'Password', :with => new_user.password
    fill_in 'Password confirmation', :with => new_user.password
    click_button 'Login'
    expect(page).to have_content 'success'
  end
  
  given(:other_user) { User.new(:email => 'other@example.com', :password => 'rous') }
  
  scenario "Registering a new user with different passwords" do
    visit new_user_registration_path
    fill_in 'Email', :with => other_user.email
    fill_in 'Password', :with => other_user.password
    fill_in 'Password confirmation', :with => other_user.email + " different"
    click_button 'Login'
    expect(page).to have_content 'don\'t match'
  end
  
end