class UserRegistersController < Devise::RegistrationsController
  # based on https://github.com/plataformatec/devise/blob/v2.0.4/app/controllers/devise/registrations_controller.rb

  set_tab :signup, :only => %w(sign_up)
  set_tab :editaccount, :only => %w(profile edit)

  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :edit_password, :update_password, :profile]

  before_filter :redirect_one_id_to_change_password_at_mq, only: [:edit_password, :update_password]

  def profile

  end

  # Override the update method in the RegistrationsController so that we don't require password on update
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update_attributes(params[resource_name])
      if is_navigational_format?
        if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
          flash_key = :update_needs_confirmation
        end
        set_flash_message :notice, flash_key || :updated
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def edit_password
    respond_with resource
  end

  # Mostly the same as the devise 'update' method, just call a different method on the model
  def update_password
    if resource.update_password(params[resource_name])
      set_flash_message :notice, :password_updated if is_navigational_format?
      sign_in resource_name, resource, :bypass => true
      redirect_to :users_profile
    else
      clean_up_passwords(resource)
      render :edit_password
    end
  end

  def redirect_one_id_to_change_password_at_mq
    if current_user.try(:is_ldap)
      redirect_to APP_CONFIG['one_id_password_reset_url']
      false
    end
  end

end
