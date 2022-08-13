require 'rails_helper'

feature 'User can remove links from question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be abble to remove links
} do

  given(:author) { create :user }
  given(:user) { create :user }
  given!(:question) { create :question, user: author }
  given!(:gist_link) { 'https://gist.github.com/Archi1881/62fd494dfdc60ebcf4e469c8f5c43268' }
  given!(:link) { create :link, name: 'Test link', url: gist_link, linkable: question }

  scenario 'Author can removes link from question', js: true do
    sign_in author
    visit question_path(question)

    within '.links' do
      click_on 'x'
    end

    expect(page).to_not have_link 'Test link', href: gist_link
  end

  scenario 'Authenticated user can not to removes the link' do
    sign_in user
    visit question_path(question)

    within '.links' do    
      expect(page).to_not have_link 'x'
    end  
  end

  scenario 'Unauthenticated user can not to removes the link' do
    visit question_path(question)

    within '.links' do    
      expect(page).to_not have_link 'x'
    end
  end
end