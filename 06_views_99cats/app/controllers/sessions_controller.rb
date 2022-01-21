class SessionsController < ApplicationController
  before_action :require_no_session!, only: [:new, :create]

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(user_params)

    if @user
      login!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = ["Username/Password combo not valid"]
      render :new
    end
  end

  def destroy
    logout!
    redirect_to cats_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end