class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(user_params)

    if @user
      if activated?(@user)
        login!(@user)
        redirect_to user_url(@user)
      else
        flash.now[:errors] = ["Please confirm email before trying to login."]
        render :new
      end
    else
      flash.now[:errors] = ["Email/Password combo incorrect."]
      render :new
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end
end