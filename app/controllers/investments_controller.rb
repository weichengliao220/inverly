class InvestmentsController < ApplicationController
  def new
    @investment = Investment.new
  end

  def create
    @investment = Investment.new(investment_params)
    @investment.user_id = current_user.id
    @investment.etf_id = params[:etf_id]
    if @investment.save
      redirect_to investment_path(@investment)
    else
      render :new
    end
  end

  def index
    @investments = Investment.all.where(user: current_user)
  end

  def show
    @investment = Investment.find(params[:id])
    @contribution = Contribution.new
    @contribution.investment_id = @investment
    counts = current_user.contributions.pluck(:date, :amount)
    sum = 0
    @cumul_count = counts.map do | date, count|
     sum = sum + count
     [date, sum]
    end
    @contributions = Contribution.all.where(investment: @investment)
  end

  private

  def investment_params
    params.require(:investment).permit(:name, :description, :risk_level, :etf_id)
  end
end
