require 'fog/test_helpers'
require File.expand_path('../../lib/fog/dnsimple', __FILE__)

Excon.defaults.merge!(debug_request: true, debug_response: true)
