class ContributionsController < ApplicationController

  def show
    @contribution = Contribution.find(params[:id])
  end

  def new
    @contribution = Contribution.new
  end

  def create
    @contribution = Contribution.new(contribution_params)
    if @contribution.save
      redirect_to @contribution
    else
      render 'new'
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
