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

    can :read, Papyrus, visibility: [Papyrus::PUBLIC, Papyrus::VISIBLE]

    return unless user and user.role

    if Role.superuser_roles.include? user.role
      can :create, Papyrus
      can :update, Papyrus
      can :view_visibility, Papyrus
      can :read, Papyrus

    elsif user.role.researcher?
      can :read, Papyrus
    end

    user.role.permissions.each do |permission| # TODO revisit
      action = permission.action.to_sym
      can action, permission.entity.constantize
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
