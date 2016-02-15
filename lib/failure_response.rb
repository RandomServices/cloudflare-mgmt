class FailureResponse < StandardError
  def initialize(response)
    @response = response
  end

  attr_reader :response

  def to_s
    "#{response.code} #{response.message} from #{response.uri}: #{response.body}"
  end
end
