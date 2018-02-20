require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(color: true)

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "fog/dnsimple"

ENV["FOG_MOCK"] ||= "true"

Excon.defaults.merge!(debug_request: true, debug_response: true)

require_relative "helpers/fog_helper"
require_relative "helpers/mock_helper"
