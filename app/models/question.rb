class Question < ApplicationRecord
  include Linkable
  include Voteable
  include Commentable

  belongs_to :user
  has_many :answers, -> { order best: :desc, created_at: :asc }, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  has_one :badge, dependent: :destroy

  accepts_nested_attributes_for :badge, allow_destroy: true,
                                        reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, presence: true

  after_create_commit :subscribe_user!

  private

  def subscribe_user!
    user.subscribe!(self)
  end
end
