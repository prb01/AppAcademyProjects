class ApplicationController < ActionController::Base
  helper_method :current_user

  def login!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  private
  
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
