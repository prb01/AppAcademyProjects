class LikesController < ApplicationController
  def index
    if params[:user_id]
      return unless user = get_user
      render json: user.liked_artworks + user.liked_comments
    elsif params[:artwork_id] && !params[:comment_id]
      return unless artwork = get_artwork
      render json: artwork.user_likes
    elsif params[:comment_id]
      return unless comment = get_comment
      render json: comment.user_likes
    end
  end

  def create
    like = Like.new(like_params)

    if like.save
      render json: like, status: 201
    else
      render json: like.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    return unless like = get_like

    if like.destroy
      render json: like
    else
      render json: like.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

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

  def get_comment
    unless comment = Comment.find_by_id(params[:comment_id])
      render json: ["Unable to find comment"], status: :unprocessable_entity
      return false
    end

    comment
  end

  def get_like
    unless like = Like.find_by_id(params[:id])
      render json: ["Unable to find like"], status: :unprocessable_entity
      return false
    end

    like
  end

  def like_params
    params.require(:like).permit(:user_id, :comment_id, :artwork_id)
  end
end