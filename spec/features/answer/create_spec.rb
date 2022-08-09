require 'rails_helper'

feature 'User can create answer', %q{
  The user on the question page
  As an authenticated user
  Can write the answer to the question
} do

  given(:user) { create :user }
  given(:question) { create :question, user: user }

  describe 'Authenticated user' do
    background do
      sign_in user

      visit question_path(question)
    end

    scenario 'gives an answer' do
      fill_in 'Body', with: 'Some Answer'
      click_on 'Add answer'

      expect(page).to have_content 'Answer successfully added'
      expect(page).to have_content 'Some Answer'
    end

    scenario 'gives an answer with errors' do
      click_on 'Add answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unuthenticated user try gives an answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Add answer'
  end

end