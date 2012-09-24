class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::Unauthorized do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
end
