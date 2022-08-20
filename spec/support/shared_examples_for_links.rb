require 'rails_helper'

RSpec.shared_examples 'linkable' do
  describe 'associations' do
    it { should have_many(:links).dependent(:destroy) }
  end

  it { should accept_nested_attributes_for :links }
end
