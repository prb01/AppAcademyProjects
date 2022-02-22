class CommentsController < ApplicationController
  before_action :require_user!

  def new
    @post = Post.find_by(id: params[:post_id])
    render :new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.author_id = current_user.id
    puts @post = @comment.post

    if @comment.save
      flash[:notify] = ["New comment added"]
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :new
    end

  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
