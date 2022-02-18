class UsersController < ApplicationController
  def new
    render :new
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notify] = ["#{@user.email} account successfully created"]
      login!(@user)
      redirect_to new_user_url
      # redirect_to subs_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def destroy
    @user = current_user
    logout!
    @user.destroy
    redirect_to subs_url
  end
end