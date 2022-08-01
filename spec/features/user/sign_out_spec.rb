require 'rails_helper'

feature 'User can sign out', %q{
  As an authenticated User
  Id like to be able to sign out
} do

  given(:user) { create :user }

  scenario 'User sign out' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end
end