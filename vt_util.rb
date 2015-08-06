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

  def charge options={}
    conn = Faraday.new(:url => self.url, :ssl => {:verify => false}) do |faraday|
      faraday.request   :url_encoded
      faraday.response  :logger
      faraday.adapter   Faraday.default_adapter
    end

    options[:payload][:transaction_details][:order_id] = rand(10000000).to_s

    response = conn.post 'charge' do |req|
      req.headers = {
        'CONTENT-TYPE' => 'application/json',
        'ACCEPT' => 'application/json',
        'AUTHORIZATION' => 'Basic ' + Base64.encode64("#{@server_key}:")
      }
      req.body  = options[:payload].to_json
    end

    JSON.parse(response.body)
  end

  def status id
    conn = Faraday.new(:url => self.url, :ssl => {:verify => false}) do |faraday|
      faraday.request   :url_encoded
      faraday.response  :logger
      faraday.adapter   Faraday.default_adapter
    end

    response = conn.get "#{id}/status" do |req|
      req.headers = {
        'CONTENT-TYPE' => 'application/json',
        'ACCEPT' => 'application/json',
        'AUTHORIZATION' => 'Basic ' + Base64.encode64("#{@server_key}:")
      }
    end

    JSON.parse(response.body)
  end

  def cancel id
    conn = Faraday.new(:url => self.url, :ssl => {:verify => false}) do |faraday|
      faraday.request   :url_encoded
      faraday.response  :logger
      faraday.adapter   Faraday.default_adapter
    end

    response = conn.post "#{id}/cancel" do |req|
      req.headers = {
        'CONTENT-TYPE' => 'application/json',
        'ACCEPT' => 'application/json',
        'AUTHORIZATION' => 'Basic ' + Base64.encode64("#{@server_key}:")
      }
    end

    JSON.parse(response.body)
  end

  def expire id
    conn = Faraday.new(:url => self.url, :ssl => {:verify => false}) do |faraday|
      faraday.request   :url_encoded
      faraday.response  :logger
      faraday.adapter   Faraday.default_adapter
    end

    response = conn.post "#{id}/expire" do |req|
      req.headers = {
        'CONTENT-TYPE' => 'application/json',
        'ACCEPT' => 'application/json',
        'AUTHORIZATION' => 'Basic ' + Base64.encode64("#{@server_key}:")
      }
    end

    JSON.parse(response.body)
  end
end

vtweb_payload = {
  :payment_type => "vtweb",

  :transaction_details => {
    :order_id => "A17550",
    :gross_amount => 145000
  },

  :vtweb => {
    :credit_card_3d_secure => true
  }
}

bank_transfer_payload = {
  payment_type: "bank_transfer",

  transaction_details: {
    order_id: "H17550",
    gross_amount: 145000
  },

  bank_transfer: {
    bank: "permata"
  }
}

mandiri_clickpay_payload = {
  payment_type: "mandiri_clickpay",
  mandiri_clickpay: {
    card_number: "4111111111111111",
    input1: "1111111111",
    input2: "145000",
    input3: "54321",
    token: "000000"
  },

  transaction_details: {
    order_id: "E17550",
    gross_amount: 145000
  }
}

bca_klikpay_payload = {
  payment_type: "bca_klikpay",

  transaction_details: {
    order_id: "orderid­01",
    gross_amount: 11000
  },

  item_details: [ {
    id: "1",
    price: 11000,
    quantity: 1,
    name: "Mobil "
    }
  ],

  bca_klikpay: {
    type: 1,
    misc_fee: 0,
    description: "Pembelian Barang"
  }
}

byebug
vt_util = VtUtil.new
# response = vt_util.charge(payload: vtweb_payload)
# byebug
# response = vt_util.charge(payload: bank_transfer_payload)
# byebug
# response = vt_util.charge(payload: mandiri_clickpay_payload)
# byebug
# response = vt_util.charge(payload: bca_klikpay_payload)
# byebug
# response = vt_util.status 1234
# byebug
# response = vt_util.cancel 1234
# byebug
# response = vt_util.expire 1234
byebug