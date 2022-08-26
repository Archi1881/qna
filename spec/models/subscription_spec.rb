require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :question }
  end

  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :question }
  end

  describe 'unique index' do
    let!(:subscription) { create :subscription }

    it { should validate_uniqueness_of(:user).scoped_to(:question_id) }
  end
end