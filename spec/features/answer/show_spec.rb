require 'rails_helper'

feature 'User can view the question', %q{
  The user can view the question 
  and answers to it.
} do

  given(:user)  { create :user }
  given!(:question) { create :question, user: user }
  given!(:answers) { create_list :q_answers, 2, question: question, user: user }

  scenario 'User view the question with answers' do
    sign_in user
    visit question_path(question)
    
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end