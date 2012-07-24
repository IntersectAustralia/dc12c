class PagesController < ApplicationController
  def home
    set_tab :home
  end

  def about
    set_tab :about
  end

  def legal
    set_tab :about
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
