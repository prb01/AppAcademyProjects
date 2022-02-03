class GoalsController < ApplicationController
  def new
    render :new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id

    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def show
    @goal = Goal.find_by(id: params[:id])

    if @goal
      render :show
    else
      flash[:errors] = ["Goal not found"]
      redirect_to new_goal_url
    end
  end

  def destroy
    @goal = Goal.find_by(id: params[:id])
    @user = @goal.user

    if @goal.destroy
      redirect_to user_url(@user)
    else
      redirect_to goal_url(@goal)
    end
  end

  def toggle_completed
    @goal = Goal.find_by(id: params[:id])
    @goal.toggle_completed
    
    redirect_back(fallback_location: user_url(@goal.user))
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :details, :private, :completed)
  end
end