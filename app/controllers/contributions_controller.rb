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
    @investment = Investment.find(params[:investment_id])
    @contribution = Contribution.new(contribution_params)
    @contribution.investment_id = @investment.id
    @contribution.date = Date.today
    @contribution.total = @contribution.amount

    if @contribution.save
      # Destroy old contributions
      Contribution.where.not(investment_id: @contribution.id).destroy_all

      # Calculate contributions
      calculate_future_contributions(@investment, @contribution)

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

  def calculate_future_contributions(investment, base_contribution)
    start_date = Date.today - 1.month
    monthly_rate = investment.etf.average_return / 12

    # Loop for optimistic, expected, and pessimistic contributions
    ['optimistic', 'expected', 'pessimistic'].each do |type|
      total = 0
      total_amount = 0
      rate_multiplier = case type
                        when 'optimistic' then 1.2
                        when 'pessimistic' then 0.8
                        else 1.0
                        end
      monthly_rate_adjusted = monthly_rate * rate_multiplier

      (1..(12 * 9)).each do |month|
        contribution = Contribution.new(contribution_params)
        contribution.investment_id = investment.id
        contribution.date = start_date + month.months
        contribution.amount = base_contribution.amount

        total_amount += contribution.amount
        contribution.total_amount = total_amount
        contribution.contribution_type = type

        total += contribution.amount
        total *= (1 + monthly_rate_adjusted)

        contribution.total = total.to_i
        contribution.save
      end
    end
  end
end
