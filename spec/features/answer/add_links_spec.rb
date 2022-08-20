require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be abble to add links
" do
  given(:author) { create :user }
  given(:question) { create :question, user: author }
  given(:gist_link) { 'https://gist.github.com/Archi1881/3257223adf647af2937cd9eadafbfe56' }

  scenario 'User adds links when asks answer', js: true do
    sign_in author
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'Some Answer'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_link

      click_on 'Add answer'
    end

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_link
    end
  end
end
