require 'will_paginate/array'

class UsersController < ApplicationController
  ONE_IDS_PER_PAGE = APP_CONFIG['number_of_one_ids_per_page']

  before_filter :authenticate_user!
  load_and_authorize_resource
  set_tab :admin

  def index
    @users = User.deactivated_or_approved
  end

  def show
  end

  def deactivate
    if !@user.check_number_of_superusers(params[:id], current_user.id) 
      redirect_to(@user, :alert => "You cannot deactivate this account as it is the only account with Administrator privileges.")
    else
      @user.deactivate
      redirect_to(@user, :notice => "The user has been deactivated.")
    end
  end

  def activate
    @user.activate
    redirect_to(@user, :notice => "The user has been activated.")
  end

  def reject
    @user.reject_access_request
    @user.destroy
    redirect_to(access_requests_users_path, :notice => "The access request for #{@user.email} was rejected.")
  end

  def reject_as_spam
    @user.reject_access_request
    redirect_to(access_requests_users_path, :notice => "The access request for #{@user.email} was rejected and this email address will be permanently blocked.")
  end

  def edit_role
    if @user == current_user
      flash.now[:alert] = "You are changing the role of the user you are logged in as."
    elsif @user.rejected?
      redirect_to(users_path, :alert => "Role can not be set. This user has previously been rejected as a spammer.")
    end
    @roles = Role.by_name
  end

  def edit_approval
    @roles = Role.by_name
  end

  def update_role
    if params[:user][:role_id].blank?
        redirect_to(edit_role_user_path(@user), :alert => "Please select a role for the user.")
    else
      @user.role_id = params[:user][:role_id]
      if !@user.check_number_of_superusers(params[:id], current_user.id)
        redirect_to(edit_role_user_path(@user), :alert => "Only one superuser exists. You cannot change this role.")
      elsif @user.save
        redirect_to(@user, :notice => "The role for #{@user.email} was successfully updated.")
      else
        raise @user.errors.inspect
      end
    end
  end

  def approve
    if !params[:user][:role_id].blank?
      @user.role_id = params[:user][:role_id]
      @user.save
      @user.approve_access_request

      redirect_to(access_requests_users_path, :notice => "The access request for #{@user.email} was approved.")
    else
      redirect_to(edit_approval_user_path(@user), :alert => "Please select a role for the user.")
    end
  end

  def new_one_id
    @search_fields = {}
    excluded_one_ids = User.existing_one_ids
    @search_fields = sanitise_search_fields(params)
    page = make_page(params[:page])

    if @search_fields.any?{|k,v|v.present?}
      @search_results = LdapSearcher.search(@search_fields.merge(excluded_one_ids: excluded_one_ids)).paginate(page: page, per_page: ONE_IDS_PER_PAGE)
    else
      flash.now[:alert] = "Please fill in at least one field." if params[:commit]
    end
  end

  def create_one_id
    attrs = LdapSearcher.search(one_id: params[:one_id]).first
    u = User.new(email: attrs[:email], first_name: attrs[:first_name], last_name: attrs[:last_name], login_attribute: attrs[:one_id], dn: attrs[:dn]) do |u|
      u.one_id = attrs[:one_id]
      u.is_ldap = true
      u.status = 'A'
      u.role = Role.researcher
      u.password = "NeverUsed.123" # TODO there should be something nicer than having to set this...
    end

    u.save!

    redirect_to(u)
  end

  def new_external
    @user = User.new
    @user.role = Role.find_by_name!("Researcher")
  end
  def create_external
    role_id = params[:user].delete(:role_id)
    @user = User.new(params[:user]) do |u|
      u.role_id = role_id
      u.is_ldap = false
      if u.email.present?
        u.login_attribute = u.email
      else
        u.login_attribute = 'junk' # suppresses the login_attribute validation error
      end
      u.status = User::APPROVED
    end
    @user.assign_random_password
    if @user.save
      Notifier.notify_user_of_account_creation(@user).deliver
      redirect_to user_path(@user), notice: "The user was successfully created. An e-mail has been sent to them with details of how to log in."
    else
      render :new_external
    end
  end

  private

  def sanitise_search_fields(params)
    params = params.slice(:one_id, :first_name, :last_name)
    params.reduce({}) do |attrs, (k, v)|
      attrs.merge k.to_sym => v.tr('*()', '')
    end
  end
end
