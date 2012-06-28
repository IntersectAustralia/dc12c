class ApplicationController < ActionController::Base
  before_filter do
    # not worth it to define a custom controller just for this change
    set_tab :signin if action_name == 'new'
  end

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

  protect_from_forgery
  # catch access denied and redirect to the home page
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  private

  def make_page(page)
    page.to_i < 1 ? 1 : page
  end

end

class MenuTabBuilder < TabsOnRails::Tabs::Builder
  def tab_for(tab, name, options, item_options = {})
    item_options[:class] = 'active' if current_tab?(tab)
    @context.content_tag(:li, item_options) do
      @context.link_to(name, options)
    end
  end
end
