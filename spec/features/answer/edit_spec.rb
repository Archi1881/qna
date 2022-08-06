require 'rails_helper'

feature 'Author can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  Id like to be able to edit my answer
} do

  given(:author) { create :user }
  given!(:user) { create :user }
  given!(:question) { create :question, user: author }
  given!(:answer) { create :answer, question: question, user: author }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated author', js: true do
    before do
      sign_in author
      visit question_path(question)
    end

    scenario 'edits his answer' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your Answer', with: 'Edited Answer'

        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited Answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your Answer', with: ''

        click_on 'Save'
      end
      
      expect(page).to have_content "Body can't be blank"
    end

    
  end

  describe 'Authenticated user', js: true do
    scenario "tries to edit other user's answer" do
      sign_in user
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end