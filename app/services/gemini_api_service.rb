# app/services/external_api_client.rb
require 'net/http'

class GeminiApiService
  API_URL = "https://api.example.com/holdings"

  def self.fetch_data(symbol)
    uri = URI("#{API_URL}?symbol=#{symbol}")
    response = Net::HTTP.get_response(uri)

    OpenStruct.new(
      success?: response.is_a?(Net::HTTPSuccess),
      body: JSON.parse(response.body),
      error_message: response.message
    )
  rescue StandardError => e
    OpenStruct.new(success?: false, error_message: e.message)
  end
end
