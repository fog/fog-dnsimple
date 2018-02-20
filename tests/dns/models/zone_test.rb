require 'test_header'

class Fog::DNS::Dnsimple::ZoneTest < Minitest::Test
  include TestModelHelpers

  def test_all
    domain_name = uniq_id + '.com'

    zone_attributes = {
      domain: domain_name
    }

    model_tests(Fog::DNS[:dnsimple].zones, zone_attributes)
  end

end
