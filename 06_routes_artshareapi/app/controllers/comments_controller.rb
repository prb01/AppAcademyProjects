class CommentsController < ApplicationController
  def index
    render json: Comment.all
  end

  def create
    comment = Comment.new(comment_params)

    if comment.save
      render json: comment, status: 201
    else
      render json: comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    return unless comment = get_comment

    if comment.destroy
      render json: comment
    else
      render json: comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def get_comment
    unless comment = Comment.find_by_id(params[:id])
      render json: ["Unable to find comment"], status: :unprocessable_entity
      return false
    end

    comment
  end

  def comment_params
    params.permit(:body, :user_id, :artwork_id)
  end
end