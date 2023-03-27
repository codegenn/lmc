# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    return unless user.permission == 2
    can :manage, [ AdminUser, User, Foundation, 
      Category, Partner, Product, Message,
      Order, Subscriber, Job, Voucher ]
  end
end
