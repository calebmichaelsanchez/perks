class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  private
    def admin_user?
      current_user.admin?
    end
end
