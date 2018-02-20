Shindo.tests("Fog::DNS[:dnsimple] | zones", ["dnsimple"]) do

  config = { mocked: false }
  domain_name = uniq_id + '.com'

  zone_attributes = {
    :domain => domain_name
  }.merge!(config[:zone_attributes] || {})

  collection_tests(Fog::DNS[:dnsimple].zones, zone_attributes, config[:mocked])

end
