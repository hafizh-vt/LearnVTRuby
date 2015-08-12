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

PERMATA_VA_PAYLOAD = {
  payment_type: "bank_transfer",

  transaction_details: {
    order_id: "H17550",
    gross_amount: 145000
  },

  bank_transfer: {
    bank: "permata"
  }
}

MANDIRI_BILL_PAYMENT_PAYLOAD = {
  payment_type: "echannel",

  transaction_details: {
    order_id: "1388",
    gross_amount: 145000
  },

  item_details: [
    {
      id: "a1",
      price: 50000,
      quantity: 2,
      name: "Apel"
    },
    {
      id: "a2",
      price: 45000,
      quantity: 1,
      name: "Jeruk"
    }
  ],

  echannel: {
    bill_info1: "Payment For:",
    bill_info2: "debt"
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

CIMB_CLICKS_PAYLOAD = {
  payment_type: "cimb_clicks",

  cimb_clicks: {
    description: "Purchase of a special event item"
  },

  transaction_details: {
    order_id: "H17550",
    gross_amount: 145000
  },

  customer_details: {
    first_name: "Andri",
    last_name: "Litani",
    email: "andri@litani.com",
    phone: "081122334455"
  }
}

EPAY_BRI_PAYLOAD = {
  payment_type: "bri_epay",

  transaction_details: {
    order_id: "2014111702",
    gross_amount: 145000
  },

  customer_details: {
    first_name: "Andri",
    last_name: "Litani",
    email: "andri@litani.com",
    phone: "081122334455"
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

TCASH_PAYLOAD = {
  payment_type: "telkomsel_cash",

  transaction_details: {
    order_id: "1388",
    gross_amount: 100000
  },

  item_details: [{
    id: "1388",
    price: 100000,
    quantity: 1,
    name: "Mie Ayam Original"
  }],

  customer_details: {
    email: "obet.supriadi@gmail.com",
    first_name: "Obet",
    last_name: "Supriadi",
    phone: "081311874839"
  },

  telkomsel_cash: {
    customer: "0811111111",
    promo: false,
    is_reversal: 0
  }
}

XL_TUNAI_PAYLOAD = {
  payment_type: "xl_tunai",

  transaction_details: {
    order_id: "1388",
    gross_amount: 100000
  }
}

BBM_MONEY_PAYLOAD = {
  payment_type: "bbm_money",

  transaction_details: {
    order_id: "1388",
    gross_amount: 100000
  }
}

INDOSAT_DOMPETKU_PAYLOAD = {
  payment_type: "indosat_dompetku",

  transaction_details: {
    order_id: "1388",
    gross_amount: 100000
  },

  item_details: [{
    id: "1388",
    price: 100000,
    quantity: 1,
    name: "Mie Ayam Original"
  }],

  customer_details: {
    email: "obet.supriadi@gmail.com",
    first_name: "Obet",
    last_name: "Supriadi",
    phone: "081311874839"
  },

  indosat_dompetku: {
    msisdn: "08123456789"
  }
}

INDOMARET_PAYLOAD = {
  payment_type: "cstore",

  transaction_details: {
    order_id: "1388",
    gross_amount: 100000
  },

  cstore: {
    store: "indomaret",
    message: "mangga"
  }
}
