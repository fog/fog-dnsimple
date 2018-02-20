require 'test_helper'

class Fog::DNS::Dnsimple::RecordsTest < Minitest::Test
  include TestCollectionHelpers

  def test_all
    domain_name = uniq_id + '.com'

    record_attributes = {
      name: 'www.' + domain_name,
      type: 'A',
      value: '1.2.3.4'
    }

    zone_attributes = {
      domain: domain_name
    }

    @zone = Fog::DNS[:dnsimple].zones.create(zone_attributes)

    collection_tests(@zone.records, record_attributes)

    @zone.destroy
  end

end
