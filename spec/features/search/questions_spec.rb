require 'sphinx_helper'

feature 'User can search for question', %q{
  As an Anyone user
  Id like to be able to search for the question
  In order to find needed question  
} do

  given!(:answer) { create :answer, body: 'Some body for the Answer' }
  given(:questions) { create_list :question, 2 }
  given!(:question) { create :question, title: 'SOME BODY Title', body: 'Body for the question' }
  given(:comment) { create :comment, commentable: answer, content: 'Some Body content for the Comment' }

  describe 'Searches for the question', sphinx: true, js: true do
    background { visit root_path }

    scenario 'with ThinkingSphinx' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: 'some body'
        select 'Question', from: :resource
        click_on 'Find'

        expect(page).to have_content question.body 

        questions.each do |question|
          expect(page).to_not have_content question.body
        end
        expect(page).to_not have_content answer.body
        expect(page).to_not have_content comment.content
      end 
    end
  end
end