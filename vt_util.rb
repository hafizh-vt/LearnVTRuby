require 'faraday'
require 'base64'
require 'byebug'
require 'json'

class VtUtil

  attr_accessor :client_key, :server_key, :url
  attr_reader :client_key, :server_key, :url

  def initialize
    self.client_key = 'VT-client-eM9pFF9VqA2__MG_'
    self.server_key = 'VT-server-3yKV0tgoORXL-YrA6F4GgStF'

    self.url = 'https://api.sandbox.veritrans.co.id/v2'
  end

  def create_connection
    conn = Faraday.new(:url => self.url, :ssl => {:verify => false}) do |faraday|
      faraday.request   :url_encoded
      faraday.response  :logger
      faraday.adapter   Faraday.default_adapter
    end
  end

  def get(conn, path)
    conn.get "#{path}" do |req|
      req.headers = {
        'CONTENT-TYPE' => 'application/json',
        'ACCEPT' => 'application/json',
        'AUTHORIZATION' => 'Basic ' + Base64.encode64("#{@server_key}:")
      }
    end
  end

  def post(conn, path, payload)
    response = conn.post path do |req|
      req.headers = {
        'CONTENT-TYPE' => 'application/json',
        'ACCEPT' => 'application/json',
        'AUTHORIZATION' => 'Basic ' + Base64.encode64("#{@server_key}:")
      }
      req.body  = payload.to_json
    end
  end

  def charge options={}
    conn = create_connection
    options[:payload][:transaction_details][:order_id] = rand(10000000).to_s
    response = post(conn, 'charge', options[:payload])
    JSON.parse(response.body)
  end

  def status id
    conn = create_connection
    response = get(conn, "#{id}/status")
    JSON.parse(response.body)
  end

  def cancel id
    conn = create_connection
    response = post(conn, "#{id}/cancel")
    JSON.parse(response.body)
  end

  def expire id
    conn = create_connection
    response = post(conn, "#{id}/expire")
    JSON.parse(response.body)
  end
end