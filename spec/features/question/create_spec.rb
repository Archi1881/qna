require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  Id like to be able to ask the question
} do

  given(:user) {create(:user)}

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
    end

    scenario 'asks a question' do
      within '.question-fields' do
        fill_in 'Question title', with: 'SomeTitle'
        fill_in 'Body', with: 'SomeBody'
      end
      click_on 'Create'

      expect(page).to have_content 'Question successfully created'
      expect(page).to have_content 'SomeTitle'
      expect(page).to have_content 'SomeBody'
    end

    scenario 'asks a question with errors' do
      click_on 'Create'

      expect(page).to have_content "Title can't be blank"
    end
  
    scenario 'asks a question with attached files' do
      within '.question-fields' do
        fill_in 'Question title', with: 'SomeTitle'
        fill_in 'Body', with: 'SomeBody'
      end
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with create a badge' do
      within '.question-fields' do
        fill_in 'Question title', with: 'SomeTitle'
        fill_in 'Body', with: 'SomeBody'
      end

      within '.badge-fields' do
        fill_in 'Badge title', with: 'Some Bage Title'
        attach_file 'Image', "#{Rails.root}/public/favicon.ico"
      end

      click_on 'Create'

      expect(page).to have_content 'Question successfully created'
      expect(page).to have_content 'Some Bage Title'
    end
  end

  scenario 'Unuthenticated user try asks a question' do
    visit new_question_path
    expect(page).to_not have_content 'Create'
  end

  describe 'Multiple sessions', js: true do
    scenario 'question appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in user
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        visit new_question_path

        within '.question-fields' do
          fill_in 'Question title', with: 'SomeTitle'
          fill_in 'Body', with: 'SomeBody'
        end

        click_on 'Create'

        expect(page).to have_content 'Question successfully created'
        expect(page).to have_content 'SomeTitle'
        expect(page).to have_content 'SomeBody'
      end

      Capybara.using_session('guest') do
        visit questions_path

        expect(page).to have_content 'SomeTitle'
      end
    end

    scenario 'question with errors not appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in user
        visit new_question_path

        within '.question-fields' do
          fill_in 'Question title', with: 'SomeTitle'
          fill_in 'Body', with: ''
        end

        click_on 'Create'

        expect(page).to have_content "Body can't be blank"
        expect(page).to_not have_content 'SomeTitle'
      end

      Capybara.using_session('guest') do
        visit questions_path

        expect(page).to_not have_content 'SomeTitle'
      end
    end
  end
end
