require "spec_helper"
require_relative "vt_util"
require_relative "payloads"

RSpec.shared_examples "papi response validation" do |status_code, transaction_status, expected_payload|
  it "expect valid response" do
    expect(response["status_code"].to_i).to eq(status_code)
    expect(response["status_message"]).to start_with("Success")
    expect(response["order_id"]).to eq(expected_payload[:transaction_details][:order_id])
    expect(response["payment_type"]).to eq(expected_payload[:payment_type])
    expect(response["transaction_status"]).to eq(transaction_status)
    expect(response["gross_amount"].to_i).to eq(expected_payload[:transaction_details][:gross_amount])
  end

  it { should have_key("transaction_id") }
end

describe VtUtil do
  it "is an instance of VtUtil class" do
    vt_util = VtUtil.new
    expect(vt_util).to be_an_instance_of(VtUtil)
  end

  describe ".charge" do

    let(:payload) {VTWEB_PAYLOAD}
    let(:response) {@response}
    subject { @response }

    before do
      vt_util = VtUtil.new
      @response = vt_util.charge payload: payload
    end

    describe "VT-Web transaction" do

      it "should charge with method VT-WEB" do
        expect(response["status_code"].to_i).to eq(201)
        expect(response["status_message"]).to start_with("OK")
        expect(response["redirect_url"]).to match(/https:\/\/vtweb\..*\/vtweb\/.*/)
      end

    end

    describe "bank transfer transaction", :focus do
      let(:payload) {BANK_TRANSFER_PAYLOAD}

      include_examples "papi response validation", 201, "pending", BANK_TRANSFER_PAYLOAD


      it "should charge with method bank transfer" do
        expect(response["transaction_status"]).to eq("pending")
        expect(response["permata_va_number"]).to_not be_nil
      end
    end

    describe "mandiri click pay transaction" do
      let(:payload) {MANDIRI_CLICKPAY_PAYLOAD}

      include_examples "papi response validation", 200, "settlement", MANDIRI_CLICKPAY_PAYLOAD
      
      it "should contains approval_code" do
        expect(response["approval_code"]).to_not be_nil
      end
    end

    it "should charge with method BCA klik pay" do
      vt_util = VtUtil.new
      response = vt_util.charge payload: BCA_KLIKPAY_PAYLOAD
      expect(response["status_code"].to_i).to eq(201)
      expect(response["status_message"]).to start_with("OK")
      expect(response["redirect_url"]).to_not be_nil
      expect(response["transaction_id"]).to_not be_nil
      expect(response["order_id"]).to eq(BCA_KLIKPAY_PAYLOAD[:transaction_details][:order_id])
      expect(response["payment_type"]).to eq(BCA_KLIKPAY_PAYLOAD[:payment_type])
      expect(response["transaction_status"]).to eq("pending")
      expect(response["gross_amount"].to_i).to eq(BCA_KLIKPAY_PAYLOAD[:transaction_details][:gross_amount])
    end

  end

  describe "Dependent Functions" do
    before do
      @vt_util = VtUtil.new
      @response = @vt_util.charge payload: BCA_KLIKPAY_PAYLOAD
    end

    describe ".status" do
      it "should be able to check transaction status using transaction id" do
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