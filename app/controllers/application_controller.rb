class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  helper_method :current_user
    
  
  rescue_from CanCan::AccessDenied do |exception|
      redirect_to guides_path, :alert => exception.message
  end    

  def configure_permitted_parameters
    attributes = [:uid]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end    
end
