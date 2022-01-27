class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?

  def login!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def activated?(user)
    user.activated
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

  def require_user!
    if current_user
      return true
    else
      redirect_to new_session_url
    end
  end
end
