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

# 10.times do
#   Etf.create(
#     name: Faker::Company.name,
#     ticker_symbol: "MMS",
#     description: Faker::Company.catch_phrase,
#     current_price: rand(1..100),
#     category: ["stocks", "bonds", "commodities"].sample,
#     average_return: rand(1..100)
#   )
# end

Etf.create(name: "SPDR S&P 500 ETF Trust", ticker_symbol: "SPY", description: "Tracks the performance of the S&P 500 Index, covering 500 of the largest U.S. companies.", category: "Large-Cap Blend")
Etf.create(name: "Invesco QQQ Trust", ticker_symbol: "QQQ", description: "Tracks the Nasdaq-100 Index, focusing on 100 of the largest non-financial companies listed on the Nasdaq Stock Market.", category: "Technology/ Growth")
Etf.create(name: "Vanguard S&P 500 ETF", ticker_symbol: "VOO", description: "Tracks the S&P 500 Index with low expense ratios and broad U.S. market exposure.", category: "Large-Cap Blend")
Etf.create(name: "iShares Russell 2000 ETF", ticker_symbol: "IWM", description: "Tracks the Russell 2000 Index, which focuses on small-cap U.S. companies.", category: "Small-Cap")
Etf.create(name: "Vanguard Total Stock Market ETF", ticker_symbol: "VTI", description: "Covers the entire U.S. stock market, including large-, mid-, small-, and micro-cap stocks.", category: "Broad Market")
Etf.create(name: "iShares MSCI Emerging Markets ETF", ticker_symbol: "EEM", description: "Tracks stocks in emerging market countries, such as China, India, and Brazil.", category: "Emerging Markets")
Etf.create(name: "Vanguard FTSE Developed Markets ETF", ticker_symbol: "VEA", description: "Covers large- and mid-cap stocks in developed markets outside the U.S. and Canada.", category: "International")
Etf.create(name: "iShares Core US Aggregate Bond ETF", ticker_symbol: "AGG", description: "Tracks a broad index of U.S. investment-grade bonds, including Treasuries, corporate, and mortgage-backed securities.", category: "Fixed Income")
Etf.create(name: "SPDR Gold Shares", ticker_symbol: "GLD", description: "Tracks the price of gold bullion, providing a way to invest in gold without holding physical assets.", category: "Commodity")
Etf.create(name: "Vanguard Dividend Appreciation ETF", ticker_symbol: "VIG", description: "Focuses on U.S. companies with a history of growing dividends, emphasizing quality and stability.", category: "Dividend/Value")
Etf.create(name: "ProShares UltraPro QQQ", ticker_symbol: "TQQQ", description: "A leveraged ETF that seeks to provide 3x the daily performance of the Nasdaq-100 Index.", category: "Leveraged/Technology Growth")
Etf.create(name: "Shares ESG Aware MSCI USA ETF", ticker_symbol: "ESGU", description: "Tracks U.S. companies with strong environmental, social, and governance (ESG) practices.", category: "ESG")
Etf.create(name: "iShares 20+ Year Treasury Bond ETF", ticker_symbol: "TLT", description: "Tracks long-term U.S. Treasury bonds with maturities of 20 years or more.", category: "Fixed Income")
Etf.create(name: "ARK Innovation ETF", ticker_symbol: "ARKK", description: "Focuses on disruptive and innovative companies in sectors like technology, healthcare, and robotics.", category: "Thematic Growth")
Etf.create(name: "Vanguard Value ETF", ticker_symbol: "VTV", description: "Tracks the CRSP US Large Cap Value Index, focusing on U.S. large-cap value-oriented companies.", category: "Large-Cap Growth")
# Etf.create(name: "", ticker_symbol: "", description: "", category: "")

puts "15 etfs created"

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
  name: "apple",
  description: Faker::Company.catch_phrase,
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

puts "Creating 10 contributions"

10.times do
  Contribution.create(
    amount: rand(1..100),
    date: Date.today,
    paid: [true, false].sample,
    investment_id: Investment.all.sample.id
  )
end

puts "10 contributions created"

puts "creating 10 favorites"

10.times do
  Favorite.create(
    user_id: User.all.sample.id,
    etf_id: Etf.all.sample.id
  )
end

puts "10 favorites created"

puts "seeded successfully"
