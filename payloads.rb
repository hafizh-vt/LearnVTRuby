VTWEB_PAYLOAD = {
  :payment_type => "vtweb",

  :transaction_details => {
    :order_id => "A17550",
    :gross_amount => 145000
  },

  :vtweb => {
    :credit_card_3d_secure => true
  }
}

BANK_TRANSFER_PAYLOAD = {
  payment_type: "bank_transfer",

  transaction_details: {
    order_id: "H17550",
    gross_amount: 145000
  },

  bank_transfer: {
    bank: "permata"
  }
}

MANDIRI_CLICKPAY_PAYLOAD = {
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

BCA_KLIKPAY_PAYLOAD = {
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