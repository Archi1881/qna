class Question < ApplicationRecord
  include Linkable
  include Voteable
  include Commentable

  belongs_to :user
  has_many :answers, -> { order best: :desc, created_at: :desc }, dependent: :destroy
  has_one :badge, dependent: :destroy

  accepts_nested_attributes_for :badge, allow_destroy: true,
                                        reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, presence: true
end
