require 'rails_helper'

feature 'User can post a comment', %q{
  As an any user
  I'd like to be able to post comment's
  For the question
} do

  given(:author) { create :user }
  given(:user) { create :user }
  given!(:question) { create :question, user: author }
  
  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'post a comment' do
      within '.question-comments' do
        click_on 'Add comment'
        fill_in 'Your comment', with: 'Some Comment'
        click_on 'Post'
      end

      expect(page).to have_content 'Some Comment'
    end

    scenario 'post a comment with errors' do
      within '.question-comments' do
        click_on 'Add comment'
        fill_in 'Your comment', with: ''
        click_on 'Post'
      end

      expect(page).to have_content "Content can't be blank"
    end
  end

  describe 'Multiple sessions', js: true do
    scenario 'comment appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)

        within '.question-comments' do
          click_on 'Add comment'
          fill_in 'Your comment', with: 'Some Comment'
          click_on 'Post'
        end

        expect(page).to have_content 'Some Comment'
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        expect(page).to have_content 'Some Comment'
      end
    end

    scenario 'comment with errors not appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)

        within '.question-comments' do
          click_on 'Add comment'
          fill_in 'Your comment', with: ''
          click_on 'Post'
        end

        expect(page).to have_content "Content can't be blank"
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        expect(page).to_not have_css '.question-comments .comments'
      end
    end
  end
end