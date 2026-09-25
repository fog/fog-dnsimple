require 'test_helper'
require 'open3'

class Fog::Dnsimple::LoadTest < Minitest::Test

  # The test process loads JSON through WebMock, so only a clean process shows a missing require.
  def test_service_loads_json_in_a_clean_process
    lib = File.expand_path("../lib", __dir__)
    output, status = Open3.capture2e(RbConfig.ruby, "-I", lib, "-e", 'require "fog/dnsimple"; Fog::Dnsimple::DNS; print defined?(JSON)')

    assert status.success?, output
    assert_equal "constant", output
  end

end
