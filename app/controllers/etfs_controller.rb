class EtfsController < ApplicationController
  def index
    if params[:query].present?
      @etfs = Etf.where("name ILIKE ?", "%#{params[:query]}%")
    else
      @etfs = Etf.all
      @etfs = @etfs.where(category: params[:category]) if params[:category].present?

    end
  end

  def create
    @etf = Etf.new(etf_params)
    if @etf.save
      redirect_to etf_path(@etf)
    end
  end

  def show
    @etf = Etf.find(params[:id])
    @power_user_investment = Investment.find_or_create_by(name: "power_user_investment", etf_id: @etf.id) do |investment|
      investment.user_id = current_user.id
      investment.amount = 0
    end

    create_contribution # Ensure contribution creation

    @contributions = @power_user_investment.contributions
    counts = @contributions.pluck(:date, :total)
    counter = 5

    @cumul_count = counts.each_with_object([]) do |(date, count), result|
      counter += 1
      next unless counter % 6 == 0

      result << [date, count]
    end

    amounts = @contributions.pluck(:date, :amount)

    amounts_counter = 5
    count_amounts = 0
    @cumul_amounts = amounts.each_with_object([]) do |(date, amount), result_amount|
      amounts_counter += 1
      count_amounts += 1
      amount = count_amounts * amount
      next unless amounts_counter % 6 == 0

      result_amount << [date, amount]
    end


    @monthly_series = @etf.monthly_times
    @top_holdings = @etf.holdings
  end


  private

  def etf_params
    params.require(:etf).permit(:name, :ticker_symbol, :description, :current_price, :category, :average_return)
  end

  def create_contribution
    return if @power_user_investment.contributions.exists?(date: Date.today)

    # Use the same logic as ContributionsController#create for consistency
    @contribution = @power_user_investment.contributions.new(
      amount: 100,
      date: Date.today
    )

    # Set total based on the existing contribution logic
    @contribution.total = @contribution.amount

    if @contribution.save
      calculate_future_contributions(@power_user_investment, @contribution)
    else
      Rails.logger.error "Failed to create contribution: #{@contribution.errors.full_messages.join(', ')}"
    end
  end

  def calculate_future_contributions(investment, base_contribution)
    @total = base_contribution.total
    start_date = base_contribution.date
    monthly_rate = investment.etf.average_return / 12

    (1..(12 * 9)).each do |month|
      contribution = investment.contributions.new(
        amount: base_contribution.amount,
        date: start_date + month.months
      )
      @total += contribution.amount
      @total *= (1 + monthly_rate)
      contribution.total = @total.round(2)
      contribution.save
    end
  end

end
