require 'rails_helper'

RSpec.shared_examples 'voteable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:author) { create(:user) }
  let(:users) { create_list(:user, 3) }
  let!(:model) { described_class }

  let(:voteable) do
    if model.to_s == 'Answer'
      question = create(:question, user: author)
      create(model.to_s.underscore.to_sym, question: question, user: author)
    else
      create(model.to_s.underscore.to_sym, user: author)
    end
  end

  describe 'Vote Positive' do
    before { voteable.positive(users.first) }

    it 'changed score' do
      expect(Vote.last.score).to eq 1
    end

    it 'vote user is a voter' do
      expect(Vote.last.user).to eq users.first
    end

    it 'voteable is a voteable' do
      expect(Vote.last.voteable).to eq voteable
    end
  end

  describe 'Vote Negative' do
    before { voteable.negative(users.first) }

    it 'changed score' do
      expect(Vote.last.score).to eq -1
    end

    it 'vote user is a voter' do
      expect(Vote.last.user).to eq users.first
    end

    it 'voteable is a voteable' do
      expect(Vote.last.voteable).to eq voteable
    end
  end

  it 'check rating score' do
    users.each { |user| voteable.positive(user) }

    expect(voteable.rating).to eq 3
  end
end
