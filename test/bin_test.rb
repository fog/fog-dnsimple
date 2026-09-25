require 'test_helper'

# Fog::Bin comes from the fog gem, which is not a dependency.
module Fog
  class Bin; end unless defined?(Fog::Bin)
end
require "fog/bin/dnsimple"

class Fog::Dnsimple::BinTest < Minitest::Test

  def test_top_level_constant_sends_bin_methods
    assert_equal [:dns], ::Dnsimple.services
    assert_equal Fog::Dnsimple::DNS, ::Dnsimple.class_for(:dns)
    assert_kind_of Class, ::Dnsimple::Client
    assert_respond_to ::Dnsimple, :class_for
    refute_respond_to ::Dnsimple, :new
  end

end
