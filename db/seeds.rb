# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

Favorite.destroy_all
Contribution.destroy_all
Investment.destroy_all
Etf.destroy_all
User.destroy_all

puts "Creating 10 users"

10.times do
  User.create(
    name: Faker::Name.first_name,
    email: Faker::Internet.email,
    password: "password",
    password_confirmation: "password"
  )
end

brian = User.create(
    name: "brian",
    email: "brian@me.com",
    password: "password",
    password_confirmation: "password"
  )

puts "10 users created"

puts "Creating 15 etfs"

file_path = Rails.root.join("db", "etf_data.json") # finds the etf_data.json file in the db folder
etf_data = JSON.parse(File.read(file_path)) # reads the file and parses it into Ruby object (array of hashes)

etf_data.each do |etf_hash| # iterates over the array of hashes
  etf = Etf.where(
    name: etf_hash["name"],
    ticker_symbol: etf_hash["ticker_symbol"],
    category: etf_hash["category"],
    description: etf_hash["description"],
    historical_data: etf_hash["historical_data"],
    current_price: etf_hash["current_price"],
    average_return: etf_hash["average_return"],
    inception_date: etf_hash["inception_date"],
    created_at: etf_hash["created_at"],
    updated_at: etf_hash["updated_at"]
  ).first_or_create! # checks if the Etf exists in the database, if not, creates it

  etf_hash["holdings"].each do |holding_hash| # a nested array in etf_hash containing the ETF's holdings data
    etf.holdings.where(
      symbol: holding_hash["symbol"],
      description: holding_hash["description"],
      weight: holding_hash["weight"],
      etf_id: holding_hash["etf_id"]
    ).first_or_create! # checks if the Holding exists in the database, if not, creates it
  end
end

def create_monthly_times(etf)
  return if etf.monthly_times.any? # skips further processing if MonthlyTime already exists for the ETF

  p response = FetchEtfData.new(etf.ticker_symbol).call_monthly_series # calls the API to fetch the ETF's monthly price data
  monthly_series = response['Monthly Time Series'] # extracts the 'Monthly Time Series' data from the API response
  if monthly_series
    dates = monthly_series.keys # extracts the keys (dates) from the monthly_series hash
    dates.each do |date|
      MonthlyTime.where(
        etf: etf,
        date_close_price: { date => monthly_series[date]['4. close'] },
      ).first_or_create! # checks if a record exists in the monthly_times table, if not, creates a new record with etf, date, and close price
    end
  else
    puts "API exceeded for #{etf.ticker_symbol}"
  end
end

def create_holdings(etf)
  return if etf.holdings.any? # skips further processing if Holding already exists for the ETF

  p response = FetchEtfData.new(etf.ticker_symbol).call_holdings # calls the API and passes the ETF's ticker symbol to fetch the ETF's holdings data
  holdings = response['holdings'] # extracts the 'holdings' data from the API response
  if holdings
    top_holdings = holdings[0..9] # selects only the top 10 holdings
    top_holdings.each do |holding|
      puts "Finding or creating... #{holding['symbol']}, #{holding['description']}, #{holding['weight']}"
      puts
      old_holding = Holding.find_by(etf: etf, symbol: holding['symbol']) # finds the holding by etf and symbol
      if old_holding
        old_holding.update(weight: holding['weight'], description: holding['description']) # updates the weight of the holding
      else
        Holding.create!(
          etf: etf,
          symbol: holding['symbol'],
          description: holding['description'],
          weight: holding['weight']
        ) # checks if a record exists in the holdings table, if not, creates a new record with etf, symbol, description, and weight
      end
    end
  else
    puts "API exceeded for #{etf.ticker_symbol}"
  end
end

# ensures the ETFs exist in the database and creating them if needed
# ensures the ETFs exist in the database and creating them if needed
etf = Etf.where(name: "SPDR S&P 500 ETF Trust", ticker_symbol: "SPY", description: "Tracks the performance of the S&P 500 Index, covering 500 of the largest U.S. companies.", category: "Large-Cap Blend", inception_date: "1993-01-22").first_or_create!
etf.update(inception_date: "1993-01-22", average_return: 8.813) # manually updates the inception date
create_holdings(etf) # calls the create_holdings method to create the ETF's holdings
create_monthly_times(etf) # calls the create_monthly_times method to create the ETF's monthly price data
etf = Etf.where(name: "Invesco QQQ Trust", ticker_symbol: "QQQ", description: "Tracks the Nasdaq-100 Index, focusing on 100 of the largest non-financial companies listed on the Nasdaq Stock Market.", category: "Technology/ Growth").first_or_create!
etf.update(inception_date: "1999-03-10", average_return: 9.479) # manually updates the inception date and average return
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "Vanguard S&P 500 ETF", ticker_symbol: "VOO", description: "Tracks the S&P 500 Index with low expense ratios and broad U.S. market exposure.", category: "Large-Cap Blend").first_or_create!
etf.update!(inception_date: "2010-09-07", average_return: 12.857)
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "iShares Russell 2000 ETF", ticker_symbol: "IWM", description: "Tracks the Russell 2000 Index, which focuses on small-cap U.S. companies.", category: "Small-Cap").first_or_create!
etf.update(inception_date: "2000-05-20", average_return: 6.684)
create_holdings(etf)
create_monthly_times(etf)
etf =Etf.where(name: "Vanguard Total Stock Market ETF", ticker_symbol: "VTI", description: "Covers the entire U.S. stock market, including large-, mid-, small-, and micro-cap stocks.", category: "Broad Market").first_or_create!
etf.update(inception_date: "2001-05-24", average_return: 7.421)
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "iShares MSCI Emerging Markets ETF", ticker_symbol: "EEM", description: "Tracks stocks in emerging market countries, such as China, India, and Brazil.", category: "Emerging Markets").first_or_create!
etf.update(inception_date: "2003-04-07", average_return: 6.701)
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "Vanguard FTSE Developed Markets ETF", ticker_symbol: "VEA", description: "Covers large- and mid-cap stocks in developed markets outside the U.S. and Canada.", category: "International").first_or_create!
etf.update(inception_date: "2007-07-20", average_return: 3.786)
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "iShares Core US Aggregate Bond ETF", ticker_symbol: "AGG", description: "Tracks a broad index of U.S. investment-grade bonds, including Treasuries, corporate, and mortgage-backed securities.", category: "Fixed Income").first_or_create!
etf.update(inception_date: "2003-09-22", average_return: -1.278)
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "SPDR Gold Shares", ticker_symbol: "GLD", description: "Tracks the price of gold bullion, providing a way to invest in gold without holding physical assets.", category: "Commodity").first_or_create!
etf.update(inception_date: "2004-11-18", average_return: 8.882)
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "Vanguard Dividend Appreciation ETF", ticker_symbol: "VIG", description: "Focuses on U.S. companies with a history of growing dividends, emphasizing quality and stability.", category: "Dividend/Value").first_or_create!
etf.update(inception_date: "2006-04-12", average_return: 8.140)
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "ProShares UltraPro QQQ", ticker_symbol: "TQQQ", description: "A leveraged ETF that seeks to provide 3x the daily performance of the Nasdaq-100 Index.", category: "Leveraged/Technology Growth").first_or_create!
etf.update(inception_date: "2010-02-09", average_return: 45.235)
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "Shares ESG Aware MSCI USA ETF", ticker_symbol: "ESGU", description: "Tracks U.S. companies with strong environmental, social, and governance (ESG) practices.", category: "ESG").first_or_create!
etf.update(inception_date: "2016-12-01", average_return: 13.480)
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "iShares 20+ Year Treasury Bond ETF", ticker_symbol: "TLT", description: "Tracks long-term U.S. Treasury bonds with maturities of 20 years or more.", category: "Fixed Income").first_or_create!
etf.update(inception_date: "2002-07-22", average_return: 5.929)
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "ARK Innovation ETF", ticker_symbol: "ARKK", description: "Focuses on disruptive and innovative companies in sectors like technology, healthcare, and robotics.", category: "Thematic Growth").first_or_create!
etf.update(inception_date: "2014-10-31", average_return: 11.022)
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "Vanguard Value ETF", ticker_symbol: "VTV", description: "Tracks the CRSP US Large Cap Value Index, focusing on U.S. large-cap value-oriented companies.", category: "Large-Cap Growth").first_or_create!
etf.update(inception_date: "2004-01-26", average_return: 6.750)
create_holdings(etf)
create_monthly_times(etf)

EtfExportJob.perform_now # executes the job defined in the EtfExportJob class (etf_export_job.rb)

puts "#{Etf.count} etfs created"

puts "Creating 10 investments"

10.times do
  Investment.create(
    user_id: User.all.sample.id,
    etf_id: Etf.all.sample.id,
    name: Faker::Company.name,
    description: Faker::Company.catch_phrase,
    risk_level: ["low", "medium", "high"].sample
  )
end

invest = Investment.create(
  user: brian,
  etf_id: Etf.all.sample.id,
  name: "Apple, Inc.",
  description: "Apple Inc. is an American multinational technology company that revolutionized the technology sector through its innovation of computer software, personal computers, mobile tablets, smartphones, and computer peripherals.",
  risk_level: ["low", "medium", "high"].sample
)

number_of_months = 12 * 10 # 10 years simulation, 120 months.
number_of_months.times do |month_index|
  date = (Date.today + month_index.months).beginning_of_month # 2024-11-01, 2024-12-01, 2025-01-01, etc.
  Contribution.create(
    amount: 30000, # JPY
    date: date,
    investment: invest,
  )
end

puts "10 investments created"

puts "creating 10 favorites"

10.times do
  Favorite.create(
    user_id: User.all.sample.id,
    etf_id: Etf.all.sample.id
  )
end

puts "10 favorites created"

puts "seeded successfully"
