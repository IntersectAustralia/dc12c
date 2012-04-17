class Ability
  include CanCan::Ability

  def initialize(user)
    # alias edit_role to update_role so that they don't have to be declared separately
    alias_action :edit_role, :to => :update_role
    alias_action :edit_approval, :to => :approve

    # alias activate and deactivate to "activate_deactivate" so its just a single permission
    alias_action :deactivate, :to => :activate_deactivate
    alias_action :activate, :to => :activate_deactivate

    # alias access_requests to view_access_requests so the permission name is more meaningful
    alias_action :access_requests, :to => :admin

    # alias reject_as_spam to reject so they are considered the same
    alias_action :reject_as_spam, :to => :reject

    # alias search to read so they are considered the same
    alias_action :search, to: :read

    # alias advanced search to read so they are considered the same
    alias_action :advanced_search, to: :read

    can :read, Papyrus, visibility: [Papyrus::PUBLIC, Papyrus::VISIBLE]

    can :low_res, Image do |image|
      [Papyrus::PUBLIC, Papyrus::VISIBLE].include? image.papyrus.visibility
    end

    can :high_res, Image do |image|
      image.papyrus.visibility == Papyrus::PUBLIC
    end

    can :read_full_field, Papyrus, visibility: [Papyrus::PUBLIC]
    can :read_detailed_field, Papyrus, visibility: [Papyrus::PUBLIC]

    return unless user and user.role

    can :request_access, Papyrus do |papyrus|
      papyrus.access_requests.where(user_id: user.id).empty?
    end
    can :cancel_access_request, Papyrus do |papyrus|
      papyrus.access_requests.where(user_id: user.id).present?
    end
    can :read, Papyrus
    can :low_res, Image

    if Role.superuser_roles.include? user.role
      can :create, Papyrus
      can :update, Papyrus
      can :view_visibility, Papyrus
      can :create, Image
      can :high_res, Image
      can :accept_or_reject, AccessRequest
      can :read, User
      can :update_role, User
      can :activate_deactivate, User
      can :admin, User
      can :reject, User
      can :approve, User
      can :read_full_field, Papyrus
    end

    can :read_detailed_field, Papyrus
    can :read_full_field, Papyrus do |papyrus|
      papyrus.access_requests.where(user_id: user.id, status: AccessRequest::APPROVED).present?
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
