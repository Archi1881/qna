class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user 
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :me, User
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id

    can [:positive, :negative], [Question, Answer] do |resource|
      !user.author? resource
    end

    can :revote, [Question, Answer] do |resource|
      resource.votes.exists?(user_id: user.id)
    end

    can :best, Answer, question: { user_id: user.id }
    can :manage, Link, linkable: { user_id: user.id }
    can :manage, ActiveStorage::Attachment do |attachment|
      user.author? attachment.record
    end
  end
end