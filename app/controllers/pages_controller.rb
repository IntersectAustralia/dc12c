class PagesController < ApplicationController
  def home
  end

  def about
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
