class CommentsController < ApplicationController
  def index
    if params[:user_id]
      return unless user = get_user
      render json: user.comments
    elsif params[:artwork_id]
      return unless artwork = get_artwork
      render json: artwork.comments
    else
      render json: Comment.all
    end
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

  def get_user
    unless user = User.find_by_id(params[:user_id])
      render json: ["Unable to find user"], status: :unprocessable_entity
      return false
    end

    user
  end

  def get_artwork
    unless artwork = Artwork.find_by_id(params[:artwork_id])
      render json: ["Unable to find artwork"], status: :unprocessable_entity
      return false
    end

    artwork
  end

  def comment_params
    params.permit(:body, :user_id, :artwork_id)
  end
end