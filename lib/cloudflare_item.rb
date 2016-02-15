require 'net/https'
require 'uri'
require 'ostruct'
require 'json'

require_relative 'failure_response'

class CloudflareItem
  def initialize(path)
    @path = path
  end

  attr_reader :path

  def get_all_items(params = {})
    page = 1
    total_expected_count = nil
    item_count = 0
    Enumerator.new do |yielder|
      loop do
        url = uri_for_query_params(params.merge(per_page: 50, page: page))
        get_request(url) do |response|
          total_expected_count ||= response["result_info"]["total_count"]
          response["result"].tap do |results|
            results.map { |r| OpenStruct.new(r) }.each do |record|
              yielder << record
            end
            item_count += results.count
          end
        end
        break if item_count >= total_expected_count
        page += 1
      end
    end
  end

  def put!(data, params = {})
    Net::HTTP::Put.new(uri_for_query_params(params), request_headers).tap do |request|
      request.body = JSON.generate data
      response = http_connection.request(request)
      if response.kind_of? Net::HTTPSuccess
        yield(response, parsed_response(response.body)) if block_given?
        return response
      else
        fail FailureResponse.new(response)
      end
    end
  end

  private

  def base_uri
    URI.parse("https://api.cloudflare.com")
  end

  def uri_for_query_params(params)
    uri = base_uri
    uri.path = path
    uri.query = URI.encode_www_form params
    uri
  end

  def http_connection
    port = base_uri.port || 443
    @http_request ||= Net::HTTP.new(base_uri.host, port).tap do |http|
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end
  end

  def get_request(uri)
    Net::HTTP::Get.new(uri, request_headers).tap do |request|
      http_connection.request(request) do |response|
        fail response unless response.kind_of? Net::HTTPSuccess
        yield(parsed_response(response.body))
      end
    end
  rescue Net::HTTPClientError => e
    fail "#{e.message}: #{uri}"
  end

  def request_headers
    {
      'X-Auth-Email' => ENV['CLOUDFLARE_EMAIL'] || fail("No CLOUDFLARE_EMAIL"),
      'X-Auth-Key' => ENV['CLOUDFLARE_API_KEY'] || fail("No CLOUDFLARE_API_KEY"),
      'Content-Type' => 'application/json',
    }
  end

  def parsed_response(raw_response)
    JSON.parse(raw_response).tap do |response|
      fail response.errors.join(', ') unless response["success"]
    end
  end
end
