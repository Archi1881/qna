require "rails_helper"

RSpec.describe NewAnswerDigestMailer, type: :mailer do
  describe 'New answer digest' do
    let(:question) { create :question }
    let(:answer) { create :answer }
    let(:mail) { NewAnswerDigestMailer.send_for(question.user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq("New Answer for question #{answer.question.title}")
      expect(mail.to).to eq [question.user.email]
      expect(mail.from).to eq(["from@example.com"])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(answer.body)
    end
  end  
end
