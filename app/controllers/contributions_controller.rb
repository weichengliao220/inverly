class ContributionsController < ApplicationController

  def show
    @contribution = Contribution.find(params[:id])
    @investment = Investment.find(params[:investment_id])
    @contribution.investment_id = @investment
    @contributions = Contribution.all.where(investment_id: @investment.id)
  end

  def new
    @contribution = Contribution.new
    @investment = Investment.find(params[:investment_id])
    @contribution = @investment.contributions.build
  end

  def create
    @contribution = Contribution.new(contribution_params)
    @investment = Investment.find(params[:investment_id])
    @contribution.investment_id = @investment.id
    @contribution.date = Date.today
    @contribution.total = @contribution.amount
    @contribution.save

    @old_contributions = Contribution.where.not(investment_id: @contribution.id)
    @old_contributions.destroy_all if @old_contributions

    @total = 0
    @total_amount = 0
    start_date = Date.today - 1.month

    monthly_rate = @investment.etf.average_return / 12

    (1..(12 * 9)).each do |month|
      contribution = Contribution.new(contribution_params)
      contribution.investment_id = @investment.id
      contribution.date = start_date + month.months
      contribution.amount = @contribution.amount

      @total_amount += contribution.amount

      contribution.total_amount = @total_amount
      contribution.total_amount += @contribution.amount
      contribution.save

      @total += contribution.amount

      @total *= (1 + monthly_rate)

      contribution.total = @total.round(2)
      contribution.save
    end

    if @total > 0
      redirect_to investment_path(@investment), notice: "Contribution created"
    else
      redirect_to investment_path(@investment), alert: "Contribution not created. errors : #{@contribution.errors.full_messages}"
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
