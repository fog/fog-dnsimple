module Fog
  module DNS
    class Dnsimple
      class Real
        # Get the details for a specific domain in your account. You
        # may pass either the domain numeric ID or the domain name
        # itself.
        #
        # ==== Parameters
        # * account_id<~String> - the account the domain belongs to
        # * zone_name<~String> - zone name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * "data"<~Hash> The representation of the domain.
        def get_domain(account_id, zone_name)
          request(
            expects:  200,
            method:   "GET",
            path:     "/#{account_id}/domains/#{zone_name}"
          )
        end
      end

      class Mock
        def get_domain(_account_id, zone_name)
          domain = self.data[:domains].find do |domain|
            domain["data"]["id"] == zone_name || domain["data"]["name"] == zone_name
          end

          response = Excon::Response.new
          response.status = 200
          response.body = domain
          response
        end
      end
    end
  end
end
