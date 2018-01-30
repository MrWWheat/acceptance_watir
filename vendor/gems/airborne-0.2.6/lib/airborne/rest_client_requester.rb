require 'rest_client'

module Airborne
  module RestClientRequester
    def make_request(method, url, options = {})
      headers = base_headers.merge(options[:headers] || {})
      verify_ssl = options[:verify_ssl] || false
      res = if method == :post || method == :patch || method == :put
        begin
          request_body = options[:body].nil? ? '' : options[:body]
          request_body = request_body.to_json if options[:body].is_a?(Hash) && options[:body].to_json["file"].nil? && options[:body].to_json["File"].nil?
          RestClient::Request.execute(method: method, url: get_url(url), verify_ssl: verify_ssl, payload: request_body, headers: headers)
        rescue RestClient::Exception => e
          e.response
        end
      else
        begin
          RestClient::Request.execute(method: method, url: get_url(url), verify_ssl: verify_ssl, headers: headers)
        rescue RestClient::Exception => e
          e.response
        end
      end
      res
    end

    private

    def base_headers
      { content_type: :json }.merge(Airborne.configuration.headers || {})
    end
  end
end
