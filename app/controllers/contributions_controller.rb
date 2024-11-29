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

    @old_contributions = Contribution.where.not(investment_id: @contribution.id)
    @old_contributions.destroy_all if @old_contributions

    @total = 0

    @contribution_1_year = Contribution.new(contribution_params)
    @contribution_1_year.investment_id = @investment.id
    @contribution_1_year.date = Date.today + 1.year
    @contribution_1_year.amount = @contribution.amount * 12

    @contribution_3_year = Contribution.new(contribution_params)
    @contribution_3_year.investment_id = @investment.id
    @contribution_3_year.date = Date.today + 3.year
    @contribution_3_year.amount = @contribution_1_year.amount * 3

    @contribution_9_year = Contribution.new(contribution_params)
    @contribution_9_year.investment_id = @investment.id
    @contribution_9_year.date = Date.today + 9.year
    @contribution_9_year.amount = @contribution_3_year.amount * 3

    @total += @contribution_9_year.amount
    @total = @total * @investment.etf.average_return


    @investment.description = "Total = #{@total}"
    @investment.save

    if @contribution.save && @contribution_1_year.save && @contribution_3_year.save
      redirect_to investment_path(@investment), notice: 'Contribution created successfully.'
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
