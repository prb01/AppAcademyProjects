class UsersController < ApplicationController
  def index
    render json: User.all
  end

  def show
     if user = User.find_by_id(params[:id])
      render json: user
    else
      render json: ["Unable to find user"], status: :unprocessable_entity
    end
  end

  def create
    user = User.new(user_params)
    
    if user.save
      render json: user, status: 201  
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end    
  end

  def update
    unless user = User.find_by_id(params[:id])
      return render json: ["Unable to find user"], status: :unprocessable_entity
    end

    if user.update(user_params)
      render json: user
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    unless user = User.find_by_id(params[:id])
      return render json: ["Unable to find user"], status: :unprocessable_entity
    end

    if user.destroy
      render json: user
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email)
  end
end