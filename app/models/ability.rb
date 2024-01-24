# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    if user.permission == 1 && user.status?
      can :manage, [Product]
    elsif user.permission == 2 && user.status?
      can :manage, [ AdminUser, User, Foundation, 
        Category, Partner, Product, Message,
        Order, Subscriber, Job, Voucher, MemberAd,
        MasterDatum, PartnerUser, Medium, PartnerOrder,
        Review, ProductSold
      ]
    else
      can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    end
  end
end
