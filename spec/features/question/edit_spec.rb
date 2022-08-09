require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  Id like to be able to edit my question
} do

  given(:author) { create :user }
  given!(:user) { create :user }
  given!(:question) { create :question, user: author }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated author', js: true do
    before do
      sign_in author
      visit question_path(question)
    end

    scenario 'edits his question' do
      click_on 'Edit'

      within '.edit-question' do
        fill_in 'Title', with: 'SomeTitle'
        fill_in 'Body', with: 'SomeBody'

        click_on 'Save'

        expect(page).to have_content 'SomeTitle'
        expect(page).to have_content 'SomeBody'
      end      
    end

    scenario 'edits his question with errors' do
      click_on 'Edit'

      within '.edit-question' do
        fill_in 'Body', with: ''

        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end


  end

  describe 'Authenticated user', js: true do
    scenario "tries to edit other user's question" do
      sign_in user
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end