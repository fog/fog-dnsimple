require "fog/core"
require_relative "dnsimple/version"

module Fog
  module Dnsimple
    extend Fog::Provider

    autoload :DNS, File.expand_path('../dnsimple/dns', __FILE__)

    service(:dns, 'DNS')
  end

  module DNS
    autoload :Dnsimple, File.expand_path('../dnsimple/dns', __FILE__)
  end
end
