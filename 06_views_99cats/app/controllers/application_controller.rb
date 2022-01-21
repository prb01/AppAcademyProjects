class ApplicationController < ActionController::Base
  helper_method :current_user

  def login!(user)
    @current_user = user
    session[:session_token] = user.reset_session_token!
  end

  def logout!
    @current_user.try(:reset_session_token!)
    session[:session_token] = nil
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def require_no_user!
    redirect_to cats_url unless current_user.nil?
  end

  def require_user!
    redirect_to cats_url if current_user.nil?
  end
end
