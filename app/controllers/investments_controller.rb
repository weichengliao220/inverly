class InvestmentsController < ApplicationController
  def new
    @investment = Investment.new
  end
  def create
    @investment = Investment.new(investment_params)
    @investment.user = current_user
  end

  def index
    @investments = Investment.all.where(user: current_user)
  end

  def show
    @investment = Investment.find(params[:id])
  end

  private

  def investment_params
    params.require(:investment).permit(:name, :description, :risk_level, :etf_id)
  end
end
