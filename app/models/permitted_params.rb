class PermittedParams < Struct.new(:params,:user)
  
  def model
    debugger
    params.require(:model).permit(*model_attributes)
  end
  
  def model_attributes
    if user && user.admin?
      [:description, :title, :is_published, :owner, :owner_id]
    else
      [:description, :title, :is_published]
    end
  end
end
