# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role?(:admin)
      can :manage, :all
    elsif user.has_role?(:author)
      can :manage, Article, user_id: user.id
    elsif user.has_role?(:reader)
      can :read, Article
    end
  end
end
