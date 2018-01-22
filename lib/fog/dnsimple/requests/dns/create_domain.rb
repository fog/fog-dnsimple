module Fog
  module DNS
    class Dnsimple
      class Real
        # Create a single domain in DNSimple in your account.
        #
        # ==== Parameters
        # * zone_name<~String> - zone name to host (ie example.com)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * "data"<~Hash> The representation of the domain.
        def create_domain(zone_name)
          body = {
            "name" => zone_name
          }

          request(
            body:     Fog::JSON.encode(body),
            expects:  201,
            method:   "POST",
            path:     "/#{@dnsimple_account}/domains"
          )
        end
      end

      class Mock
        def create_domain(zone_name)
          body = {
            "id"                 => Fog::Mock.random_numbers(1).to_i,
            "account_id"         => @dnsimple_account,
            "registrant_id"      => nil,
            "name"               => zone_name,
            "unicode_name"       => zone_name,
            "token"              => "4fIFYWYiJayvL2tkf_mkBkqC4L+4RtYqDA",
            "state"              => "registered",
            "auto_renew"         => nil,
            "private_whois"     => false,
            "expires_on"         => Date.today + 365,
            "created_at"         => Time.now.iso8601,
            "updated_at"         => Time.now.iso8601,
          }
          self.data[:domains] << body

          response = Excon::Response.new
          response.status = 201
          response.body = { "data" => body }
          response
        end
      end
    end
  end
end
