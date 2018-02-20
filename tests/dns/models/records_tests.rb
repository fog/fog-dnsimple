Shindo.tests("Fog::DNS[:dnsimple] | records", ["dnsimple"]) do

  config = { mocked: false }
  domain_name = uniq_id + '.com'

  record_attributes = {
    :name   => 'www.' + domain_name,
    :type   => 'A',
    :value  => '1.2.3.4'
  }.merge!(config[:record_attributes] || {})

  if !Fog.mocking? || config[:mocked]
    zone_attributes = {
      :domain => domain_name
    }.merge(config[:zone_attributes] || {})

    @zone = Fog::DNS[:dnsimple].zones.create(zone_attributes)

    collection_tests(@zone.records, record_attributes, config[:mocked])

    @zone.destroy
  end

end
