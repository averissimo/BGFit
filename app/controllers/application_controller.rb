class ApplicationController < ActionController::Base
  helper_method :sort_column, :sort_direction
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
  
  def sort_column(klass,pref=nil)
    if klass.column_names.include?(params[:sort].downcase)
      params[:sort]
    else
      pref.nil? ? klass.column_names.first : pref
    end
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
