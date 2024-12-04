class Holding < ApplicationRecord
  belongs_to :etf

  def fetch_data_if_needed
    return if last_fetched_at&.to_date == Date.today # Skip if already fetched today

    # Fetch data from the API
    response = GeminiApiService.fetch_data(symbol)

    if response.success?
      update(
        ai_resume: response.body["ai_resume"], # Assuming API returns "ai_resume" field
        last_fetched_at: Time.current
      )
    else
      Rails.logger.error("API Request failed for #{symbol}: #{response.error_message}")
    end
  end
end
