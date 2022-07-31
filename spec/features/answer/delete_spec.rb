require 'rails_helper'

feature 'Delete his answer', %q{
  must be log in
  must be an author of answer
} do

  given(:author) { create :user }
  given(:user) { create :user }
  given!(:question) { create :question, user: author }
  given!(:answer) { create :answer, question: question, user: author }


  scenario 'Authenticated Author tries to delete his answer' do
    sign_in author
    visit question_path(question)

    expect(page).to have_content answer.body

    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully deleted'  
  end

  scenario "Authenticated User tries to delete another's answer" do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end