class NewAnswerDigestMailer < ApplicationMailer
  def send_for(user, answer)
    @user = user
    @answer = answer

    mail to: @user.email,
      subject: "New Answer for question #{@answer.question.title}"
  end
end