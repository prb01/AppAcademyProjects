class SessionsController < ApplicationController
  def new
    render :new
  end
  
  def create
    @user = User.find_by_credentials(user_params[:email], user_params[:password])
  
    if @user
      flash[:notify] = ["#{@user.email} account successfully logged in"]
      login!(@user)
      redirect_to subs_url
    else
      flash.now[:errors] = ["Email/Password combo not valid"]
      render :new
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end
end