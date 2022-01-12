class ArtworkSharesController < ApplicationController
  def create
    art_share = ArtworkShare.new(art_share_params)

    if art_share.save
      render json: art_share, status: 201
    else
      render json: art_share.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    return unless art_share = get_art_share

    if art_share.destroy
      render json: art_share
    else
      render json: art_share.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def get_art_share
    unless art_share = ArtworkShare.find_by_id(params[:id])
      render json: ["Unable to find artwork share"], status: :unprocessable_entity
      return false
    end

    art_share
  end

  def art_share_params
    params.permit(:artwork_id, :viewer_id)
  end
end