require "spec_helper"
require_relative "vt_util"

describe VtUtil do
	it "is a VtUtil class" do
		vt_util = VtUtil.new
		vt_util.class.to_s.expect == 'VtUtil'
	end

	it
end