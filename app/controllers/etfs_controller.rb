class EtfsController < ApplicationController
  def index
    @etfs = Etf.all
  end

  def create
    @etf = Etf.new(etf_params)
    if @etf.save
      redirect_to etf_path(@etf)
    end
  end

  def show
    @etf = Etf.find(params[:id])
  end
end
