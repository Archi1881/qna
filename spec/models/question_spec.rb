require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'voteable'
  it_behaves_like 'commentable'

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
        
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)  
  end
end
