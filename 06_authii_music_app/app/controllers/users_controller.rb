class UsersController < ApplicationController
  before_action :require_user!, only: [:show]

  def show
    @user = User.find_by(id: params[:id])
    render :show
  end

  def new
    render :new
  end

  def create
    @user = User.new(user_params)
    

    if @user.save
      msg = UserMailer.activation_email(@user)
      msg.deliver
      redirect_to new_session_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def activate
    @user = User.find_by(activation_token: params[:activation_token])
    
    if @user
      @user.activated = true
      @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      flash[:errors] = ["Incorrect token"]
      redirect_to new_session_url
    end
  end
end