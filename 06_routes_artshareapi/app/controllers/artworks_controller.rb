class ArtworksController < ApplicationController
  def index
    return unless artist = get_user
    render json: artist.artworks + artist.viewed_artworks
  end

  def show
    return unless artwork = get_artwork
    render json: artwork
  end

  def create
    artwork = Artwork.new(artwork_params)

    if artwork.save
      render json: artwork, status: 201
    else
      render json: artwork.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    return unless artwork = get_artwork

    if artwork.update(artwork_params)
      render json: artwork
    else
      render json: artwork.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    return unless artwork = get_artwork

    if artwork.destroy
      render json: artwork
    else
      render json: artwork.errors.full_messages, status: :unprocessable_entity
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
    unless artwork = Artwork.find_by_id(params[:id])
      render json: ["Unable to find artwork"], status: :unprocessable_entity
      return false
    end

    artwork
  end

  def artwork_params
    params.require(:artwork).permit(:title, :artist_id, :image_url)
  end
end