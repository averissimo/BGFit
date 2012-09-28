class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::Unauthorized do |exception|
    if request.referer.nil? || request.referer.blank? 
      redirect_to root_url, :alert => exception.message
    else
      redirect_to request.referer, :alert => exception.message
    end
  end
private
  
  def permitted_params
    @permitted_params ||= PermittedParams.new(params,current_user)
  end
  helper_method :permitted_params
  
end
