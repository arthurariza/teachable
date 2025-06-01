class Teachable::Base
  include HTTParty

  NotOkResponse = Class.new(StandardError)

  base_uri ENV.fetch("TEACHABLE_BASE_URI")
  headers "Accept" => "application/json", "apiKey" => ENV.fetch("TEACHABLE_API_KEY")
end
