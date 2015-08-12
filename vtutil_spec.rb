require "spec_helper"
require_relative "vt_util"
require_relative "payloads"

RSpec.shared_examples "charge: generic papi response validation" do |status_code, status_message, payment_type, transaction_status, payload|
  let(:payload) {payload}

  it "should has valid status code" do
    expect(response["status_code"].to_i).to eq(status_code)
  end

  it "status message should indicates success" do
    expect(response["status_message"]).to start_with(status_message)
  end

  it "payment type should match" do
    expect(response["payment_type"]).to eq(payment_type)
  end

  it "transaction status should match" do
    expect(response["transaction_status"]).to eq(transaction_status)
  end

  it "gross amount should match" do
    expect(response["gross_amount"].to_i).to eq(payload[:transaction_details][:gross_amount])
  end

  it "order id should match" do
  expect(response["order_id"]).to eq(payload[:transaction_details][:order_id])
  end

  it { should have_key("transaction_id") }
end

describe VtUtil do
  it "is an instance of VtUtil class" do
    vt_util = VtUtil.new
    expect(vt_util).to be_an_instance_of(VtUtil)
  end

  describe ".charge" do
    let(:response) { @response }
    subject { @response }

    before do
      vt_util = VtUtil.new
      @response = vt_util.charge payload: payload
    end

    describe "vt-web transaction" do
      let(:payload) { VTWEB_PAYLOAD }
      it "should charge with method VT-WEB" do
        expect(response["status_code"].to_i).to eq(201)
        expect(response["status_message"]).to start_with("OK")
        expect(response["redirect_url"]).to match(/https:\/\/vtweb\..*\/vtweb\/.*/)
      end
    end

    describe "bank transfer transaction" do
      let(:payload) { BANK_TRANSFER_PAYLOAD }
      include_examples "charge: generic papi response validation", 201, "Success", "bank_transfer", "pending", BANK_TRANSFER_PAYLOAD
      it { should have_key("permata_va_number") }
    end

    describe "mandiri click pay transaction" do
      let(:payload) { MANDIRI_CLICKPAY_PAYLOAD }
      include_examples "charge: generic papi response validation", 200, "Success", "mandiri_clickpay", "settlement", MANDIRI_CLICKPAY_PAYLOAD
      it { should have_key("approval_code") }
    end

    describe "should charge with method BCA klik pay" do
      let(:payload) { BCA_KLIKPAY_PAYLOAD }
      include_examples "charge: generic papi response validation", 201, "OK", "bca_klikpay", "pending", BCA_KLIKPAY_PAYLOAD
      it { should have_key("redirect_url") }
    end

  end

  describe "Dependent Methods" do
    before do
      @vt_util = VtUtil.new
      @response = @vt_util.charge payload: BCA_KLIKPAY_PAYLOAD
    end

    describe ".status" do
      it "should be able to check transaction status using transaction id", :focus do
        resp = @vt_util.status @response["transaction_id"]
        expect(resp["status_code"].to_i).to eq(201)
        expect(resp["transaction_status"]).to eq("pending")
        expect(resp["transaction_id"]).to eq(@response["transaction_id"])
      end

      it "should be able to check transaction status using order id" do
        resp = @vt_util.status BCA_KLIKPAY_PAYLOAD[:transaction_details][:order_id]
        expect(resp["status_code"].to_i).to eq(201)
        expect(resp["transaction_status"]).to eq("pending")
        expect(resp["order_id"]).to eq(BCA_KLIKPAY_PAYLOAD[:transaction_details][:order_id])
      end
    end

    describe ".expire" do
      it "should be able to set transaction status to expired" do
        resp = @vt_util.expire @response["transaction_id"]
        expect(resp["status_code"].to_i).to eq(407)
        expect(resp["transaction_status"]).to eq("expire")
        expect(resp["transaction_id"]).to eq(@response["transaction_id"])

        resp = @vt_util.status @response["transaction_id"]
        expect(resp["status_code"].to_i).to eq(407)
        expect(resp["transaction_status"]).to eq("expire")
        expect(resp["transaction_id"]).to eq(@response["transaction_id"])
      end
    end

    describe ".cancel" do
      it "should be able to cancel transaction" do
        resp = @vt_util.cancel @response["transaction_id"]
        expect(resp["status_code"].to_i).to eq(200)
        expect(resp["status_message"]).to start_with("Success")
        expect(resp["transaction_status"]).to eq("cancel")
        expect(resp["transaction_id"]).to eq(@response["transaction_id"])

        resp = @vt_util.status @response["transaction_id"]
        expect(resp["status_code"].to_i).to eq(200)
        expect(resp["transaction_status"]).to eq("cancel")
        expect(resp["transaction_id"]).to eq(@response["transaction_id"])
      end
    end
  end

end
