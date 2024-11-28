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
    @investment = Investment.new
    @investment.etf_id = @etf
    @investment.user_id = current_user
    @etfs = Etf.all.where(etf_id: @etf.id)

    response = FetchEtfData.new(@etf.ticker_symbol).call
    monthly_series = response['Monthly Time Series']
    dates = monthly_series.keys
    parsed_monthly_series = {}
    dates.each do |date|
      parsed_monthly_series[date] = monthly_series[date]['4. close']
    end
    raise
  end

  private

  def etf_params
    params.require(:etf).permit(:name, :ticker_symbol, :description, :current_price, :category, :average_return)
  end
end
