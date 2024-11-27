class FavoritesController < ApplicationController
  def create
    etf = Etf.find(params[:etf_id])
    current_user.favorites.create(etf: etf)
    redirect_to etfs_path, notice: "#{etf.name} added to favorites!"
  end

  def destroy
    favorite = current_user.favorites.find_by(etf_id: params[:etf_id])
    favorite&.destroy
    redirect_to etfs_path, notice: "#{favorite.etf.name} removed from favorites!"
  end
end
