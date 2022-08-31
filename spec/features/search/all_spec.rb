require 'sphinx_helper'

feature 'User can search for All', %q{
  As an Anyone user
  Id like to be able to search for All
} do

  given(:commentable_question) { create :question }
  given(:questions) { create_list :question, 2 }
  given(:question) { create :question, body: 'Testable Content for the Quetion' }
  given(:comments) { create_list :comment, 2, commentable: commentable_question }
  given!(:comment) { create :comment, commentable: question, content: 'Testable Content for the comment' }
  given!(:answer) { create :answer, body: 'Testable content for the answer' }
  given(:answers) { create_list :answer, 2 }
  given!(:user) { create :user, email: 'my@testable.email' }
  given(:users) { create_list :user, 2 }

  describe 'Searches for All', sphinx: true, js: true do
    background { visit root_path }

    scenario 'with ThinkingSphinx' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: 'testable'
        select 'All', from: :resource
        click_on 'Find'

        expect(page).to have_content comment.content
        expect(page).to have_content question.body
        expect(page).to have_content answer.body
        expect(page).to have_content user.email

        comments.each do |comment|
          expect(page).to_not have_content comment.content
        end

        questions.each do |question|
          expect(page).to_not have_content question.body
        end

        answers.each do |answer|
          expect(page).to_not have_content answer.body
        end

        users.each do |user|
          expect(page).to_not have_content user.email
        end
      end
    end
  end
end