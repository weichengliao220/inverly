class Holding < ApplicationRecord
  belongs_to :etf

  def fetch_data_if_needed
    Rails.logger.info("Fetching data for #{description}")
    return if last_fetched_at&.to_date == Date.today # Skip if already fetched today

    # Call the Node.js script to fetch the AI-generated resume
    response = GeminiApiService.fetch_data(description)

    if response.success?
      # Update AI resume and last fetched time only if successful
      update(
        ai_resume: response.body["ai_resume"], # Assuming API returns "ai_resume" field
        last_fetched_at: Time.current
      )
    else
      Rails.logger.error("API Request failed for #{description}: #{response.error_message}")
    end
  end
end
