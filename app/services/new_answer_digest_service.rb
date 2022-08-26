class NewAnswerDigestService
  def send_notification(answer)
    users = User.joins(:subscriptions).where(subscriptions: { question_id: answer.question })

    users.find_each do |user|
      NewAnswerDigestMailer.send_for(user, answer).deliver_later
    end
  end
end