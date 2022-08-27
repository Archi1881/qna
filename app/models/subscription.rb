class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :user, :question, presence: true

  validates_uniqueness_of :user, scope: :question_id
end