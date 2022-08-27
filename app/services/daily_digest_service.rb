class DailyDigestService
  def send_digest
    return unless Question.where(created_at: Date.yesterday.all_day).exists?

    User.find_each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end