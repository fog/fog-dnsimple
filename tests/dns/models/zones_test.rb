require 'test_helper'

class Fog::DNS::Dnsimple::ZonesTest < Minitest::Test
  include TestCollectionHelpers

  def test_all
    domain_name = uniq_id + '.com'

    zone_attributes = {
        domain: domain_name
    }

    collection_tests(Fog::DNS[:dnsimple].zones, zone_attributes)
  end

end
