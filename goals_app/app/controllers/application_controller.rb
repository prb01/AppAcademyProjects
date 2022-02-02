class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?
  helper_method :goal_owner?

  def login!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def goal_owner?(goal)
    !current_user.goals.include?(goal).nil?
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def require_user!
    redirect_to new_session_url unless current_user
  end

  def require_goal_owner!
    unless goal_owner?(Goal.find_by[id: params[:id]])
      redirect_back(fallback_location: new_session_url)
    end
  end
end
