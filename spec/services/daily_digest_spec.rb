require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list :user, 2 }

  describe 'Yesterdays questions exists' do
    let!(:questions) { create_list :question, 2, created_at: Date.yesterday, user: users.last }

    it 'sends daily digest to all users' do
      users.each do |user|
        expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original
      end

      subject.send_digest
    end
  end

  describe 'Yesterdays questions dosn\'t exists' do
    let!(:today_questions) { create_list :question, 2 }
    let!(:questions) { create_list :question, 2, created_at: Date.yesterday-1 }

    it 'dosn\'t sends daily digest' do
      users.each do |user|
        expect(DailyDigestMailer).to_not receive(:digest)
      end

      subject.send_digest
    end
  end