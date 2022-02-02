class UsersController < ApplicationController
  def new
    render :new
  end

  def show
    @user = User.find_by(id: params[:id])
    render :show
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end