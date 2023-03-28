# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    if user.permission == 1 
      can :manage, [Product]
    elsif user.permission == 2
      can :manage, [ AdminUser, User, Foundation, 
        Category, Partner, Product, Message,
        Order, Subscriber, Job, Voucher]
    else
      can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    end
  end
end
