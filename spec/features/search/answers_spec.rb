require 'sphinx_helper'

feature 'User can search for the answer', %q{
  As an Anyone user
  Id like to be able to search for the answer
  In order to find needed answer  
} do

  given(:comment) { create :comment, commentable: question, content: 'Some Body content for the Comment' }
  given!(:question) { create :question, body: 'Some Body content for the question' }
  given(:answers) { create_list :answer, 2 }
  given!(:answer) { create :answer, body: 'Some Body content for the answer' }

  describe 'Searches for the answers', sphinx: true, js: true do
    background { visit root_path }

    scenario 'with ThinkingSphinx' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: 'some body'
        select 'Answer', from: :resource
        click_on 'Find'

        expect(page).to have_content answer.body 

        answers.each do |answer|
          expect(page).to_not have_content answer.body
        end
        expect(page).to_not have_content question.body
        expect(page).to_not have_content comment.content
      end 
    end
  end
end