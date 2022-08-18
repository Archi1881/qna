class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
  validates_uniqueness_of :provider, scope: :uid 
end
