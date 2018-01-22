module Fog
  module DNS
    class Dnsimple
      class Real
        # Get the list of domains in the account.
        #
        # ==== Parameters
        # * account_id<~String> - the account the domains belong to
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * <~Array>:
        #       * "data"<~Hash> The representation of the domain.
        def list_domains(account_id)
          request(
            expects:  200,
            method:   "GET",
            path:     "/#{account_id}/domains"
          )
        end
      end

      class Mock
        def list_domains(_account_id)
          response = Excon::Response.new
          response.status = 200
          response.body = self.data[:domains]
          response
        end
      end
    end
  end
end
