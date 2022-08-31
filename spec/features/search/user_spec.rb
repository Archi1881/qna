require 'sphinx_helper'

feature 'User can search for users', %q{
  As an Anyone user
  Id like to be able to search for the user
  In order to find needed user  
} do

  given!(:question) { create :question, body: 'Uniq body for the Question' }
  given!(:comment) { create :comment, commentable: question, content: 'Uniq content for the Comment' }
  given(:answer) { create :answer, body: 'Uniq body for the Answer' }
  given!(:user) { create :user, email: 'my@uniq.email' }
  given(:users) { create_list :user, 2 }

  describe 'Searches for the users', sphinx: true, js: true do
    background { visit root_path }

    scenario 'with ThinkingSphinx' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: 'uniq'
        select 'User', from: :resource
        click_on 'Find'

        expect(page).to have_content user.email

        users.each do |user|
          expect(page).to_not have_content user.email
        end
        expect(page).to_not have_content answer.body
        expect(page).to_not have_content comment.content
        expect(page).to_not have_content question.body
      end 
    end
  end
end