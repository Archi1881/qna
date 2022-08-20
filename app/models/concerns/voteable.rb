module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def positive(user)
    vote!(user, 1)
  end

  def negative(user)
    vote!(user, -1)
  end

  def rating
    votes.sum(:score)
  end

  private

  def vote!(user, value)
    votes.create!(user: user, score: value) unless user.voted?(self)
  end
end
