class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top]
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # ログイン後のパスを指定(sns認証時も)
  def after_sign_in_path_for(resource)
    posts_path
  end

  # deviseのpermitted_parameterを追加する
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
  end
end
