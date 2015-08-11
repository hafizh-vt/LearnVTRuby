require_relative 'payloads'
require_relative 'vt_util'

#byebug
vt_util = VtUtil.new
# response = vt_util.charge(payload: VTWEB_PAYLOAD)
# byebug
# response = vt_util.charge(payload: BANK_TRANSFER_PAYLOAD)
# byebug
# response = vt_util.charge(payload: MANDIRI_CLICKPAY_PAYLOAD)
# byebug
# response = vt_util.charge(payload: BCA_KLIKPAY_PAYLOAD)
# byebug
# response = vt_util.status "fa696397-cd10-404c-b3c8-f1db0a94b2e9"
# byebug
# response = vt_util.cancel 1234
# byebug
 response = vt_util.expire "fa696397-cd10-404c-b3c8-f1db0a94b2e9"
byebug

byebug