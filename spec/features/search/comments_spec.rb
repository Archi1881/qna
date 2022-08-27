require 'sphinx_helper'

feature 'User can search for comment', %q{
  As an Anyone user
  Id like to be able to search for the comment
  In order to find needed comment  
} do

  given(:commentable_question) { create :question }
  given(:question) { create :question, body: 'Test Content for the Quetion' }
  given(:comments) { create_list :comment, 2, commentable: commentable_question }
  given!(:comment) { create :comment, commentable: question, content: 'Test Content for the comment' }
  given!(:answer) { create :answer, body: 'Test content for the answer' }

  describe 'Searches for the comments', sphinx: true, js: true do
    background { visit root_path }

    scenario 'with ThinkingSphinx' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: 'test content'
        select 'Comment', from: :resource
        click_on 'Find'

        expect(page).to have_content comment.content

        comments.each do |comment|
          expect(page).to_not have_content comment.content
        end
        expect(page).to_not have_content question.body
        expect(page).to_not have_content answer.body
      end
    end
  end
end