class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: Date.yesterday.all_day)

    mail to: user.email, subject: "Daily Digest of Questions"
  end
end