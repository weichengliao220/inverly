require 'net/http'
require 'open3'

class GeminiApiService
  API_URL = "https://api.example.com/holdings" # This may be used if needed

  def self.fetch_data(description)
    # Call the Node.js script to fetch the AI-generated resume
    command = "node #{Rails.root.join('app/javascript/index.js')} #{description}"
    stdout, stderr, status = Open3.capture3(command)

    if status.success?
      Rails.logger.info("API Response: #{stdout.strip}")
      # Assuming the Node.js script prints the AI-generated resume to stdout
      OpenStruct.new(
        success?: true,
        body: { "ai_resume" => stdout.strip },  # Strip to remove any extra newline/whitespace
        error_message: nil
      )
    else
      # Log the error and return failure
      Rails.logger.error("Error running Node.js script: #{stderr}")
      OpenStruct.new(success?: false, error_message: stderr)
    end
  end
end
