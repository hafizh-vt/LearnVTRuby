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
      describe "permata va transaction" do
        let(:payload) { PERMATA_VA_PAYLOAD }
        include_examples "charge: generic papi response validation", 201, "Success", "bank_transfer", "pending", PERMATA_VA_PAYLOAD
        it { should have_key("permata_va_number") }
      end

      describe "mandiri bill payment" do
        let(:payload) { MANDIRI_BILL_PAYMENT_PAYLOAD }
        include_examples "charge: generic papi response validation", 201, "Success", "echannel", "pending", MANDIRI_BILL_PAYMENT_PAYLOAD
        it { should have_key("biller_code") }
        it { should have_key("bill_key") }
      end
    end

    describe "direct debit transaction" do
      describe "mandiri click pay transaction" do
        let(:payload) { MANDIRI_CLICKPAY_PAYLOAD }
        include_examples "charge: generic papi response validation", 200, "Success", "mandiri_clickpay", "settlement", MANDIRI_CLICKPAY_PAYLOAD
        it { should have_key("approval_code") }
        it { should have_key("masked_card") }
      end

      describe "cimb clicks transaction" do
        let(:payload) { CIMB_CLICKS_PAYLOAD }
        include_examples "charge: generic papi response validation", 201, "Success", "cimb_clicks", "pending", CIMB_CLICKS_PAYLOAD
        it { should have_key("redirect_url") }
      end

      describe "epay bri transaction" do
        let(:payload) { EPAY_BRI_PAYLOAD }
        include_examples "charge: generic papi response validation", 201, "Success", "bri_epay", "pending", EPAY_BRI_PAYLOAD
        it { should have_key("redirect_url") }
      end

      describe "BCA klik pay transaction" do
        let(:payload) { BCA_KLIKPAY_PAYLOAD }
        include_examples "charge: generic papi response validation", 201, "OK", "bca_klikpay", "pending", BCA_KLIKPAY_PAYLOAD
        it { should have_key("redirect_url") }
      end
    end

    describe "e-wallet transaction" do
      describe "telkomsel tcash transaction" do
        let(:payload) { TCASH_PAYLOAD }
        include_examples "charge: generic papi response validation", 200, "Success", "telkomsel_cash", "settlement", TCASH_PAYLOAD
      end

      describe "xl tunai transaction" do
        let(:payload) { XL_TUNAI_PAYLOAD }
        include_examples "charge: generic papi response validation", 201, "Success", "xl_tunai", "pending", XL_TUNAI_PAYLOAD
        it { should have_key("xl_tunai_order_id") }
        it { should have_key("xl_tunai_merchant_id") }
      end

      describe "bbm money transaction" do
        let(:payload) { BBM_MONEY_PAYLOAD }
        include_examples "charge: generic papi response validation", 201, "Success", "bbm_money", "pending", BBM_MONEY_PAYLOAD
        it { should have_key("permata_va_number") }
      end

      describe "indosat dompetku transaction" do
        let(:payload) { INDOSAT_DOMPETKU_PAYLOAD }
        include_examples "charge: generic papi response validation", 200, "Success", "indosat_dompetku", "settlement", INDOSAT_DOMPETKU_PAYLOAD
      end
    end

    describe "convenience store transaction" do
      describe "indomaret transaction" do
        let(:payload) { INDOMARET_PAYLOAD }
        include_examples "charge: generic papi response validation", 201, "Success", "cstore", "pending", INDOMARET_PAYLOAD
        it { should have_key("payment_code") }
      end
    end

  end

  RSpec.shared_examples "dependent methods: generic papi response validation" do |status_code, transaction_status|
    before do
      @resp = @vt_util.status @response["transaction_id"]
    end

    it "status code should indicates transaction success" do
      expect(@resp["status_code"].to_i).to eq(status_code)
    end

    it "transaction status should match" do
      expect(@resp["transaction_status"]).to eq(transaction_status)
    end

    it "transaction id should match" do
      expect(@resp["transaction_id"]).to eq(@response["transaction_id"])
    end
  end

  describe "Dependent Methods" do
    before do
      @vt_util = VtUtil.new
      @response = @vt_util.charge payload: BCA_KLIKPAY_PAYLOAD
    end

    describe ".status" do

      describe "should be able to check transaction status using transaction id" do
        include_examples "dependent methods: generic papi response validation", 201, "pending"
      end

      it "should be able to check transaction status using order id" do
        resp = @vt_util.status BCA_KLIKPAY_PAYLOAD[:transaction_details][:order_id]
        expect(resp["status_code"].to_i).to eq(201)
        expect(resp["transaction_status"]).to eq("pending")
        expect(resp["order_id"]).to eq(BCA_KLIKPAY_PAYLOAD[:transaction_details][:order_id])
      end
    end

    describe ".expire" do
      before do
        @resp = @vt_util.expire @response["transaction_id"]
      end

      it "return valid response" do
        expect(@resp["status_code"].to_i).to eq(407)
        expect(@resp["transaction_status"]).to eq("expire")
        expect(@resp["transaction_id"]).to eq(@response["transaction_id"])
      end

      include_examples "dependent methods: generic papi response validation", 407, "expire"
    end

    describe ".cancel", :focus do
      before do
        @resp = @vt_util.cancel @response["transaction_id"]
      end

      it "return valid response" do
        expect(@resp["status_code"].to_i).to eq(200)
        expect(@resp["status_message"]).to start_with("Success")
        expect(@resp["transaction_status"]).to eq("cancel")
        expect(@resp["transaction_id"]).to eq(@response["transaction_id"])
      end

      include_examples "dependent methods: generic papi response validation", 200, "cancel"
    end
  end

end
