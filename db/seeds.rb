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

power_user = User.create(
    name: "power_user",
    email: "poweruser@me.com",
    password: "password",
    password_confirmation: "password"
  )

puts "power user created"


brian = User.create(
    name: "brian",
    email: "brian@me.com",
    password: "password",
    password_confirmation: "password"
  )

puts "brian created"


puts "Creating etfs"

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

# ensures the ETFs exist in the database and creating them if needed
etf = Etf.where(name: "SPDR S&P 500 ETF Trust", ticker_symbol: "SPY", description: "Tracks the performance of the S&P 500 Index, covering 500 of the largest U.S. companies.", category: "Large-Cap Blend").first_or_create!
etf = Etf.where(name: "Invesco QQQ Trust", ticker_symbol: "QQQ", description: "Tracks the Nasdaq-100 Index, focusing on 100 of the largest non-financial companies listed on the Nasdaq Stock Market.", category: "Technology/ Growth").first_or_create!
etf = Etf.where(name: "Vanguard S&P 500 ETF", ticker_symbol: "VOO", description: "Tracks the S&P 500 Index with low expense ratios and broad U.S. market exposure.", category: "Large-Cap Blend").first_or_create!
etf = Etf.where(name: "iShares Russell 2000 ETF", ticker_symbol: "IWM", description: "Tracks the Russell 2000 Index, which focuses on small-cap U.S. companies.", category: "Small-Cap").first_or_create!
etf = Etf.where(name: "Vanguard Total Stock Market ETF", ticker_symbol: "VTI", description: "Covers the entire U.S. stock market, including large-, mid-, small-, and micro-cap stocks.", category: "Broad Market").first_or_create!
etf = Etf.where(name: "iShares MSCI Emerging Markets ETF", ticker_symbol: "EEM", description: "Tracks stocks in emerging market countries, such as China, India, and Brazil.", category: "Emerging Markets").first_or_create!
etf = Etf.where(name: "Vanguard FTSE Developed Markets ETF", ticker_symbol: "VEA", description: "Covers large- and mid-cap stocks in developed markets outside the U.S. and Canada.", category: "International").first_or_create!
etf = Etf.where(name: "iShares Core US Aggregate Bond ETF", ticker_symbol: "AGG", description: "Tracks a broad index of U.S. investment-grade bonds, including Treasuries, corporate, and mortgage-backed securities.", category: "Fixed Income").first_or_create!
etf = Etf.where(name: "SPDR Gold Shares", ticker_symbol: "GLD", description: "Tracks the price of gold bullion, providing a way to invest in gold without holding physical assets.", category: "Commodity").first_or_create!
etf = Etf.where(name: "Vanguard Dividend Appreciation ETF", ticker_symbol: "VIG", description: "Focuses on U.S. companies with a history of growing dividends, emphasizing quality and stability.", category: "Dividend/Value").first_or_create!
etf = Etf.where(name: "ProShares UltraPro QQQ", ticker_symbol: "TQQQ", description: "A leveraged ETF that seeks to provide 3x the daily performance of the Nasdaq-100 Index.", category: "Leveraged/Technology Growth").first_or_create!
etf = Etf.where(name: "Shares ESG Aware MSCI USA ETF", ticker_symbol: "ESGU", description: "Tracks U.S. companies with strong environmental, social, and governance (ESG) practices.", category: "ESG").first_or_create!
etf = Etf.where(name: "iShares 20+ Year Treasury Bond ETF", ticker_symbol: "TLT", description: "Tracks long-term U.S. Treasury bonds with maturities of 20 years or more.", category: "Fixed Income").first_or_create!
etf = Etf.where(name: "ARK Innovation ETF", ticker_symbol: "ARKK", description: "Focuses on disruptive and innovative companies in sectors like technology, healthcare, and robotics.", category: "Thematic Growth").first_or_create!
etf = Etf.where(name: "Vanguard Value ETF", ticker_symbol: "VTV", description: "Tracks the CRSP US Large Cap Value Index, focusing on U.S. large-cap value-oriented companies.", category: "Large-Cap Growth").first_or_create!

EtfExportJob.perform_now # executes the job defined in the EtfExportJob class (etf_export_job.rb)

puts "Creating investments"

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
    total: 100,
    investment: invest,
  )
end

puts "#{Investment.count} investments created"

puts "creating favorites"
puts "generating power_user contributions & investments"


Etf.all.each do |etf|
  if etf.holdings.last == nil
    Investment.where(etf_id: etf.id).each do |investment|
      investment.contributions.each do |contribution|
        contribution.delete
      end
      investment.delete
    end
    etf.delete
  end
  invest = Investment.create(
    user: power_user,
    etf_id: etf.id,
    name: "power_user_investment",
  )
end

Investment.all.each do |etf|
  etf.risk_level = ["low", "medium", "high"].sample
  etf.save
end

puts "#{User.count} created"
puts "#{Investment.count} created"
puts "#{Etf.count} etfs created"

puts "updating holding summary"

Holding.all.each do |holding|
  holding.fetch_data_seed
end

puts "holding summary updated"

puts "seeded successfully"
