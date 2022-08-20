require 'rails_helper'

feature 'User can vote', '
  As an Authenticated user
  Id like to be able to vote
' do
  given(:author) { create :user }
  given(:user) { create :user }
  given!(:question) { create :question, user: author }

  describe 'Authenticated author', js: true do
    before do
      sign_in author
      visit question_path(question)
    end

    scenario 'can not vote for his question' do
      within '.vote' do
        expect(page).to_not have_link 'Positive'
        expect(page).to_not have_link 'Negative'
      end
    end
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can vote Positive' do
      within '.vote' do
        click_on 'Positive'

        expect(page).to have_content 'Rating: 1'
        expect(page).to_not have_link 'Positive'
        expect(page).to have_link 'Revote'
      end
      expect(page).to have_content 'Voted positive'
    end

    scenario 'can vote Negative' do
      within '.vote' do
        click_on 'Negative'

        expect(page).to have_content 'Rating: -1'
        expect(page).to_not have_link 'Positive'
        expect(page).to have_link 'Revote'
      end
      expect(page).to have_content 'Voted negative'
    end

    scenario 'can Revote' do
      within '.vote' do
        click_on 'Positive'
        click_on 'Revote'

        expect(page).to have_content 'Rating: 0'
        expect(page).to have_link 'Positive'
        expect(page).to_not have_link 'Revote'
      end
    end
  end
end
