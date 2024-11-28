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
  end

  def index
    @investments = Investment.all.where(user: current_user)
  end

  def show
    # api call
    # beginning_value = response.start_value
    # ending_value = response.end_value
    # inception_year = response.inception_year
    @average_rate_of_return = average_rate_of_return()
    @conservative_rate_of_return = conservative_rate_of_return
    @optimistic_rate_of_return = optimistic_rate_of_return
    number_of_months_for_table = [36, 60 , 84, 120, 180, 240, 360]
    @future_values_for_table = future_value(100, @average_rate_of_return, number_of_months_for_table)
    number_of_months_for_graph = [36, 72, 108, 144, 180, 216, 252, 288, 324, 360]
    @future_values_for_graph = future_value(100, @average_rate_of_return, number_of_months_for_graph)
    raise
  end

  def average_rate_of_return(beginning_value = rand((100.0)..(150.0)), ending_value = rand((450.0)..(500.0)), inception_year = rand(2000..2010))
    ((ending_value.fdiv(beginning_value)) ** (1.0 / (2024 - inception_year))) - 1
  end

  def conservative_rate_of_return
    average_rate_of_return * 0.8
  end

  def optimistic_rate_of_return
    average_rate_of_return * 1.2
  end

  def future_value(default_contribution = 100, rate_of_return, number_of_months)
    future_values = {}
    number_of_months.each do |number_of_month|
       future_values[number_of_month/12] = (default_contribution * (1 + (rate_of_return / 12)) ** number_of_month - 1) / (rate_of_return / 12)
    end
    future_values

    # @investment = Investment.find(params[:id])
    # counts = current_user.contributions.pluck(:date, :amount)
    # sum = 0
    # @cumul_count = counts.map do | date, count|
    #  sum = sum + count
    #  [date, sum]
    # end
  end

  private

  def investment_params
    params.require(:investment).permit(:name, :description, :risk_level, :etf_id)
  end
end
