class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: %i[github twitter vkontakte]

  has_many :authorizations, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badges, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author?(resource)
    id == resource.user_id
  end

  def voted?(resource)
    votes.exists?(voteable_id: resource)
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization!(auth)
    self.authorizations.create!(provider: auth.provider, uid: auth.uid)
  end

  def subscribed_of?(resource)
    subscriptions.exists?(question_id: resource)
  end

  def subscribe!(resource)
    subscriptions.create!(question_id: resource.id)
  end

  def unsubscribe!(resource)
    subscriptions.destroy!(question_id: resource.id)
  end
end
