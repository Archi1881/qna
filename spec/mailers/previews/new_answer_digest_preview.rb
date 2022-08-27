# Preview all emails at http://localhost:3000/rails/mailers/new_answer_digest
class NewAnswerDigestPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer_digest/digest
  def digest
    NewAnswerDigestMailer.digest
  end

end
