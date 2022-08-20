require 'rails_helper'

feature 'User can register', '
 As a new user
 I want to register
' do
  background { visit new_user_registration_path }

  scenario 'New registration' do
    fill_in 'Email', with: 'test@user.com'
    fill_in 'Password', with: 'testpass'
    fill_in 'Password confirmation', with: 'testpass'
    click_on 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
  end

  scenario 'New registration with blank Email' do
    fill_in 'Password', with: 'testpass'
    fill_in 'Password confirmation', with: 'testpass'
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end

  scenario 'New registration with blank Password' do
    fill_in 'Email', with: 'test@user.com'
    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end
end
