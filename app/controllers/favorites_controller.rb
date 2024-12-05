class FavoritesController < ApplicationController
  def index
    @favorites = current_user.favorite_etfs
  end

  def create
    etf = Etf.find(params[:etf_id])
    current_user.favorites.create(etf: etf)
    redirect_back(fallback_location: etfs_path)
  end

  def destroy
    favorite = current_user.favorites.find_by(etf_id: params[:etf_id])
    favorite_name = favorite&.etf&.name
    favorite&.destroy
    redirect_back(fallback_location: etfs_path)
  end
end
