class InvestmentsController < ApplicationController
  def new
    @investment = Investment.new
  end

  def create
    @investment = Investment.new(investment_params)
    @investment.user = current_user

    number_of_months = 12 * 30 # 30 years of simulation, 360 months
    number_of_months.times do |month_index|
      date = (Date.today + month_index.months).beginning_of_month
      Contribution.new(
        default_contribution: 100,
        date: date,
        investment: @investment,
      )
  end

  def index
    @investments = Investment.all.where(user: current_user)
  end

  def average_rate_of_return
    @ending_value =
    @beginning_value =
    @average_rate_of_return = ((ending_value / beginning_value) ** (1 / inception_year - Year.now)) - 1
  end

  def conservative_rate_of_return
    @conservative_rate_of_return = average_rate_of_return * 0.8
  end

  def optimistic_rate_of_return
    @optimistic_rate_of_return = average_rate_of_return * 1.2
  end

  def future_value
    @default_contribution = 100
    @number_of_months = 360
    @future_value = (@default_contribution * (1 + (average_rate_of_return? / 12)) ** @number_of_months? - 1) / (average_rate_of_return? / 12)
  end

  private

  def investment_params
    params.require(:investment).permit(:name, :description, :risk_level, :etf_id)
  end
end
