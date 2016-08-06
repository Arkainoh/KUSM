class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:real_team])
#    devise_parameter_sanitizer.permit(:sign_up, keys: [:team])

    devise_parameter_sanitizer.permit(:account_update, keys: [:real_team])
  end
  
end

# name 추가하기 위해 application을 바꿧음
#  [:real_team] [:team]