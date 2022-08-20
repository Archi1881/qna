require 'rails_helper'

feature 'User can sign in with OAuth', %q{
  As an unauthenticated User
  Id like to be able to sign in
  With OAuth provider
} do

  background { visit new_user_session_path }

  scenario 'GitHub' do
    github_mock
    click_on 'Sign in with GitHub'

    expect(page).to have_content github_mock.email
    expect(page).to have_content 'Successfully authenticated from github account.'
  end

  scenario 'Vkontakte' do
    vkontakte_mock
    click_on 'Sign in with Vkontakte'

    fill_in 'Your Email:', with: 'test@user.wtf'
    click_on 'Send email'

    open_email('test@user.wtf')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'test@user.wtf'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end