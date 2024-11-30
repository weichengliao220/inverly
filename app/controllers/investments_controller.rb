class InvestmentsController < ApplicationController
  def new
    @etf = Etf.find(params[:etf_id])
    @investment = @etf.investments.build
  end


  def create
    @investment = Investment.new(investment_params)
    @investment.user = current_user

    counter = current_user.investments.count
    @etf = Etf.find(params[:etf_id])
    @investment = @etf.investments.build(investment_params)
    @investment.user = current_user
    if @investment.name.blank?
      @investment.name = "investment n°#{counter + 1}"
    end

    if @investment.save
      redirect_to investment_path(@investment), notice: 'Investment created successfully.'
    else
      redirect_to etf_path(@etf), alert: 'Investment not created. Please try again.'
    end
  end

  def index
    @investments = Investment.all.where(user: current_user)
  end

  def show
    @investment = Investment.find(params[:id])
    @etf = @investment.etf

    @average_return = @etf.average_return
    @conservative_return = conservative_return(@etf.average_return)
    @optimistic_return = optimistic_return(@etf.average_return)
    number_of_months_for_table = [36, 60 , 84, 120, 180, 240, 360]
    @future_values_for_table = future_value(100, @average_return, number_of_months_for_table)
    number_of_months_for_graph = [36, 72, 108, 144, 180, 216, 252, 288, 324, 360]
    @future_values_for_graph = future_value(100, @average_return, number_of_months_for_graph)
    @contributions = @investment.contributions
    @contribution = Contribution.new
  end

  private

  def investment_params
    params.require(:investment).permit(:name, :description, :risk_level, :etf_id)
  end

  def conservative_return(average_return)
    average_return * 0.8
  end

  def optimistic_return(average_return)
    average_return * 1.2
  end

  def future_value(default_contribution = 100, rate_of_return, number_of_months)
    future_values = {}
    number_of_months.each do |number_of_month|
       future_values[number_of_month/12] = (default_contribution * (1 + (rate_of_return / 12)) ** number_of_month - 1) / (rate_of_return / 12)
    end
    future_values
  end

end
