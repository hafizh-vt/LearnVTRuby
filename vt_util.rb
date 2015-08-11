require 'faraday'
require 'base64'
require 'byebug'
require 'json'

class VtUtil

  attr_reader :client_key, :server_key, :url, :conn

  def initialize
    @client_key = 'VT-client-eM9pFF9VqA2__MG_'
    @server_key = 'VT-server-3yKV0tgoORXL-YrA6F4GgStF'

    @url = 'https://api.sandbox.veritrans.co.id/v2'
    @conn ||= create_connection
  end

  def charge options={}
    options[:payload][:transaction_details][:order_id] = rand(10000000).to_s
    post('charge', options[:payload])
  end

  def status id
    get("#{id}/status")
  end

  def cancel id
    post("#{id}/cancel")
  end

  def expire id
    post("#{id}/expire")
  end

  private

  def create_connection
    Faraday.new(:url => self.url, :ssl => {:verify => false}) do |faraday|
      faraday.request   :url_encoded
      #faraday.response  :logger
      faraday.adapter   Faraday.default_adapter
    end
  end

  def get(path)
    response = conn.get "#{path}" do |req|
      req.headers = {
        'CONTENT-TYPE' => 'application/json',
        'ACCEPT' => 'application/json',
        'AUTHORIZATION' => 'Basic ' + Base64.encode64("#{@server_key}:")
      }
    end
    JSON.parse(response.body)
  end

  def post(path, payload={})
    response = conn.post path do |req|
      req.headers = {
        'CONTENT-TYPE' => 'application/json',
        'ACCEPT' => 'application/json',
        'AUTHORIZATION' => 'Basic ' + Base64.encode64("#{@server_key}:")
      }
      req.body  = payload.to_json
    end
    JSON.parse(response.body)
  end
end