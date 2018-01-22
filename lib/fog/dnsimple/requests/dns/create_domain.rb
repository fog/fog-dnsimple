module Fog
  module DNS
    class Dnsimple
      class Real
        # Create a single domain in DNSimple in your account.
        #
        # ==== Parameters
        # * account_id<~String> - the account the domain belong to
        # * domain_name<~String> - domain name to host (ie example.com)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * "data"<~Hash> The representation of the domain.
        def create_domain(account_id, domain_name)
          body = {
            "name" => domain_name
          }

          request(
            body:     Fog::JSON.encode(body),
            expects:  201,
            method:   "POST",
            path:     "/#{account_id}/domains"
          )
        end
      end

      class Mock
        def create_domain(account_id, domain_name)
          body = {
            "data" =>  {
              "id"                 => Fog::Mock.random_numbers(1).to_i,
              "account_id"         => account_id,
              "registrant_id"      => nil,
              "name"               => domain_name,
              "unicode_name"       => domain_name,
              "token"              => "4fIFYWYiJayvL2tkf_mkBkqC4L+4RtYqDA",
              "state"              => "registered",
              "auto_renew"         => nil,
              "private_whois"     => false,
              "expires_on"         => Date.today + 365,
              "created_at"         => Time.now.iso8601,
              "updated_at"         => Time.now.iso8601,
            }
          }
          self.data[:domains] << body

          response = Excon::Response.new
          response.status = 201
          response.body = body
          response
        end
      end
    end
  end
end
