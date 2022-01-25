class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    render json: @user.email.to_json
  end

  def new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end
end