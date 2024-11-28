class ContributionsController < ApplicationController

  def show
    @contribution = Contribution.find(params[:id])
    @investment = Investment.find(params[:investment_id])
    @contribution.investment_id = @investment
    @contributions = Contribution.all.where(investment_id: @investment.id)
  end

  def new
    @contribution = Contribution.new
  end

  def create
    @contribution = Contribution.new(contribution_params)
    if @contribution.save
      redirect_to investment_path(@contribution.investment_id)
    else
      redirect_to investment_path(@contribution.investment_id)
    end
  end

  def edit
    @contribution = Contribution.find(params[:id])
  end

  private

  def contribution_params
    params.require(:contribution).permit(:amount, :investment_id)
  end
end
