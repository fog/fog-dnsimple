module Fog
  module Dnsimple
    class Bin < Fog::Bin
      class << self
        def class_for(key)
          case key
          when :dns
            Fog::Dnsimple::DNS
          else
            raise ArgumentError, "Unrecognized service: #{key}"
          end
        end

        def [](service)
          @@connections ||= Hash.new do |hash, key|
            hash[key] = case key
            when :dns
              Fog::DNS.new(provider: "Dnsimple")
            else
              raise ArgumentError, "Unrecognized service: #{key.inspect}"
            end
          end
          @@connections[service]
        end

        def services
          Fog::Dnsimple.services
        end
      end
    end
  end
end

# fog finds the provider bin at the top-level Dnsimple constant, but the dnsimple gem owns that module.
# Thus the module sends the bin methods to Fog::Dnsimple::Bin.
module Dnsimple
  def self.method_missing(name, *args, &block)
    bin_method?(name) ? Fog::Dnsimple::Bin.public_send(name, *args, &block) : super
  end

  def self.respond_to_missing?(name, include_private = false)
    bin_method?(name) || super
  end

  def self.bin_method?(name)
    Fog::Dnsimple::Bin.singleton_methods.include?(name.to_sym)
  end
  private_class_method :bin_method?
end
