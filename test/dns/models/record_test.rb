require 'test_helper'

class Fog::DNS::Dnsimple::RecordTest < Minitest::Test
  include TestModelHelpers

  def test_all
    domain_name = uniq_id + '.com'

    a_record_attributes = {
        :name   => 'a.' + domain_name,
        :type   => 'A',
        :value  => '1.2.3.4'
    }

    aaaa_record_attributes = {
        :name   => 'aaaa.' + domain_name,
        :type   => 'AAAA',
        :value  => '2001:0db8:0000:0000:0000:ff00:0042:8329'
    }

    cname_record_attributes = {
        :name   => 'cname.' + domain_name,
        :type   => 'CNAME',
        :value  => 'real.' + domain_name
    }

    zone_attributes = {
        :domain => domain_name
    }

    @zone = Fog::DNS[:dnsimple].zones.create(zone_attributes)

    model_tests(@zone.records, a_record_attributes)
    model_tests(@zone.records, aaaa_record_attributes)
    model_tests(@zone.records, cname_record_attributes)

    @zone.destroy
  end

end
