class CommentsController < ApplicationController
  before_action :require_user!

  def create
    @comment = Comment.new(comment_params)
    @comment.author_id = current_user.id
    @comment.commentable_type = params[:user_id] ? "User" : "Goal"
    @comment.commentable_id = params[:user_id] ? params[:user_id] : params[:goal_id]

    if @comment.save
      redirect_back fallback_location: users_url
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_back fallback_location: users_url
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end