require 'rails_helper'

feature 'Set a best answers', '
  Author of question
  Set one of answers
  As the best answer
' do
  given(:author) { create :user }
  given(:user) { create :user }
  given(:question) { create :question, user: author }
  given!(:answer) { create :answer, question: question, user: user }
  given!(:other_answer) { create :answer, question: question, user: user }

  describe 'Authenticated question author', js: true do
    background do
      sign_in author
      visit question_path(question)
    end

    scenario 'set the best answer' do
      within ".answer-#{answer.id}" do
        click_on 'Best answer'

        expect(page).to_not have_link 'Best answer'
      end
    end

    scenario 'choose Another best answer' do
      within ".answer-#{answer.id}" do
        click_on 'Best answer'

        expect(page).to_not have_link 'Best answer'
      end

      within ".answer-#{other_answer.id}" do
        click_on 'Best answer'

        expect(page).to_not have_link 'Best answer'
      end
    end

    scenario 'sees the best answer first' do
      within ".answer-#{answer.id}" do
        click_on 'Best answer'
      end

      within '.answers' do
        expect(first(:xpath, './/..')).to have_css ".answer-#{answer.id}"
      end
    end
  end

  describe 'A Non author of question', js: true do
    scenario 'tries to set the best answer' do
      sign_in user

      visit question_path(question)

      expect(page).to_not have_link 'Best answer'
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to set the best answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Best answer'
    end
  end
end
