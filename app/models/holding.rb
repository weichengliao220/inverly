class Holding < ApplicationRecord
  belongs_to :etf

  def fetch_data_if_needed
    Rails.logger.info("Fetching data for #{description}")
    return if last_fetched_at&.to_date == Date.today.month # Skip if already fetched today

    # Call the Node.js script to fetch the AI-generated resume
    response = GeminiApiService.fetch_data(description)

    if response.success?
      # Update AI resume and last fetched time only if successful
      update(
        ai_resume: response.body["ai_resume"], # Assuming API returns "ai_resume" field
        last_fetched_at: Date.today.month
      )
    else
      Rails.logger.error("API Request failed for #{description}: #{response.error_message}")
    end
  end

  def fetch_data_seed
    Rails.logger.info("Starting data seed process.")
    puts "Starting data seed process."
    # Efficiently delete all nameless holdings
    nameless_count = Holding.where(description: "n/a").delete_all
    nameless = Holding.where(description: "").delete_all
    Rails.logger.info("Deleted #{nameless_count} and #{nameless} nameless holdings.")

    puts "cleared nameless holdings, remaininng : #{Holding.count}"

    Etf.all.each do |etf|
      # Sort holdings by weight in descending order
      top_holdings = etf.holdings.order(weight: :desc).limit(5)

      # Get IDs of holdings to keep
      top_holding_ids = top_holdings.pluck(:id)

      # Delete holdings not in the top 5
      etf.holdings.where.not(id: top_holding_ids).delete_all

      Rails.logger.info("ETF #{etf.name}: Retained top 5 holdings, deleted the rest.")
    end

    puts "reduced the max number of holdings per etf to 5, remaining : #{Holding.count}"

    api_counter = 0

    # Iterate over all holdings and fetch data
    Holding.all.each do |holding|
      Rails.logger.info("Fetching data for holding: #{holding.description}")

      puts "starting gemini call number #{api_counter}, waiting 15 seconds"
      api_counter += 1
      sleep 15
      # Fetch data using the holding's description
      response = GeminiApiService.fetch_data(holding.description)

      if response.success?
        # Update the current holding with AI resume and last fetched date
        holding.update(
          ai_resume: response.body["ai_resume"], # Assuming API returns "ai_resume" field
          last_fetched_at: Date.today # Record the full date
        )
        Rails.logger.info("Successfully updated holding: #{holding.description}")
      else
        Rails.logger.error("API Request failed for #{holding.description}: #{response.error_message}")
      end
    end

    Rails.logger.info("Data seed process completed.")
  end
end
