# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role?(:admin)
      can :manage, :all
    else
      can %i[read create delete], Article if user.has_role?(:author, Article)
      can :read, Article if user.has_role?(:reader, Article)
    end
  end
end
