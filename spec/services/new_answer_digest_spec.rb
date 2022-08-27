require 'rails_helper'

RSpec.describe NewAnswerDigestService do
  let(:users) { create_list :user, 2 }
  let(:question) { create :question, user: users.first }
  let(:answer) { create :answer, question: question, user: users.last }

  it 'sends notification to author of question' do
    expect(NewAnswerDigestMailer).to receive(:send_for).with(users.first, answer).and_call_original
    subject.send_notification(answer)
  end
end