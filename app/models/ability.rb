class Ability
  include CanCan::Ability

  def self.none
    new(nil)
  end

  def initialize(user)
    # alias edit_role to update_role so that they don't have to be declared separately
    alias_action :edit_role, :to => :update_role
    alias_action :edit_approval, :to => :approve

    # alias activate and deactivate to "activate_deactivate" so its just a single permission
    alias_action :deactivate, :to => :activate_deactivate
    alias_action :activate, :to => :activate_deactivate

    # alias reject_as_spam to reject so they are considered the same
    alias_action :reject_as_spam, :to => :reject

    alias_action :search, to: :read
    alias_action :advanced_search, to: :read

    alias_action :revoke, to: :admin
    alias_action :reject, to: :admin
    alias_action :approve, to: :admin
    alias_action :approved, to: :admin
    alias_action :pending, to: :admin
    alias_action :access_requests, to: :admin

    alias_action :new_one_id, to: :create
    alias_action :create_one_id, to: :create

    alias_action :new_external, to: :create
    alias_action :create_external, to: :create


    can :read, Papyrus, visibility: [Papyrus::PUBLIC, Papyrus::VISIBLE]

    can :low_res, Image do |image|
      [Papyrus::PUBLIC, Papyrus::VISIBLE].include? image.papyrus.visibility
    end

    can :thumbnail, Image do |image|
      [Papyrus::PUBLIC, Papyrus::VISIBLE].include? image.papyrus.visibility
    end

    can :high_res, Image do |image|
      image.papyrus.visibility == Papyrus::PUBLIC
    end

    can :read_full_field, Papyrus, visibility: [Papyrus::PUBLIC]
    can :read_detailed_field, Papyrus, visibility: [Papyrus::PUBLIC]

    can :read, Collection

    return unless user and user.role

    can :request_access, Papyrus do |papyrus|
      papyrus.access_requests.where(user_id: user.id).empty?
    end
    can :cancel_access_request, Papyrus do |papyrus|
      papyrus.access_requests.where(user_id: user.id).present?
    end
    can :read, Papyrus
    can :low_res, Image
    can :thumbnail, Image

    if Role.superuser_roles.include? user.role
      can :create, Papyrus
      can :update, Papyrus
      can :view_visibility, Papyrus
      can :create, Image
      can :update, Image
      can :high_res, Image
      can :destroy, Image
      can :manage, Name
      can :manage, Connection
      can :accept_or_reject, AccessRequest
      can :read, User
      can :create, User
      can :update_role, User
      can :activate_deactivate, User
      can :admin, User
      can :admin, AccessRequest
      can :read, AccessRequest
      can :reject, User
      can :approve, User
      can :read_full_field, Papyrus
      can :change_visibility, Papyrus
      can :make_visible, Papyrus, visibility: [Papyrus::HIDDEN, Papyrus::PUBLIC]
      can :make_public, Papyrus, visibility: [Papyrus::HIDDEN, Papyrus::VISIBLE]
      can :make_hidden, Papyrus, visibility: [Papyrus::PUBLIC, Papyrus::VISIBLE]
      can :manage, Collection
    end

    can :read_detailed_field, Papyrus
    can :read_full_field, Papyrus do |papyrus|
      papyrus.access_requests.where(user_id: user.id, status: AccessRequest::APPROVED).present?
    end
    can :high_res, Image do |image|
      image.papyrus.access_requests.where(user_id: user.id, status: AccessRequest::APPROVED).present?
    end






    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
