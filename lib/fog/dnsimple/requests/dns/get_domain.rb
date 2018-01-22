module Fog
  module DNS
    class Dnsimple
      class Real
        # Get the details for a specific domain in your account. You
        # may pass either the domain numeric ID or the domain name
        # itself.
        #
        # ==== Parameters
        # * account_id<~String> - the account the domain belong to
        # * domain_id<~String> - domain name or numeric ID
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * "data"<~Hash> The representation of the domain.
        def get_domain(account_id, domain_id)
          request(
            expects:  200,
            method:   "GET",
            path:     "/#{account_id}/domains/#{domain_id}"
          )
        end
      end

      class Mock
        def get_domain(_account_id, domain_id)
          domain = self.data[:domains].find do |domain|
            domain["data"]["id"] == domain_id || domain["data"]["name"] == domain_id
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
