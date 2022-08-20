require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:voteable) }
  it { should belong_to(:user) }

  it { should validate_presence_of :score }
  it { should validate_numericality_of(:score).only_integer }
end
