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

  scenario "Signing in as another user" do
    visit new_user_session_path
    fill_in 'Email', :with => other_user.email
    fill_in 'Password', :with => other_user.password
    click_button 'Login'
    expect(page).to have_content 'Invalid email or password'
  end

end