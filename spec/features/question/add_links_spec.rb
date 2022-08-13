require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be abble to add links
} do

  given(:user) { create :user }
  given(:gist_link) { 'https://gist.github.com/Archi1881/62fd494dfdc60ebcf4e469c8f5c43268' }

  scenario 'User adds links when asks question' do
    sign_in user
    visit new_question_path

    fill_in 'Question title', with: 'Some Title'
    fill_in 'Body', with: 'Some Body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_link

    click_on 'Create'

    expect(page).to have_link 'My gist', href: gist_link
  end
end