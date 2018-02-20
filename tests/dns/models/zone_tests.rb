Shindo.tests("Fog::DNS[:dnsimple] | zone", ["dnsimple"]) do

  config = { mocked: false }
  domain_name = uniq_id + '.com'

  zone_attributes = {
    :domain => domain_name
  }.merge!(config[:zone_attributes] || {})

  model_tests(Fog::DNS[:dnsimple].zones, zone_attributes, config[:mocked])

end
