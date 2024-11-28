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
    @investment = Investment.find_by(id: params[:investment_id])
    unless @investment
      redirect_to investments_path, alert: 'Investment not found.'
      return
    end

    @contribution = @investment.contributions.build(contribution_params)

    if @contribution.save
      redirect_to investment_path(@investment), notice: 'Contribution created successfully.'
    else
      redirect_to investment_path(@investment), notice: 'Contribution not created.'
    end
  end

  def edit
    @contribution = Contribution.find(params[:id])
  end

  private

  def contribution_params
    params.require(:contribution).permit(:amount, :date, :paid)
  end
end
