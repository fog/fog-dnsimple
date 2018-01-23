module Fog
  module DNS
    class Dnsimple
      class Real
        # Get the list of domains in the account.
        #
        # ==== Parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * "data"<~Array>:
        #       * <~Hash> The representation of the domain.
        def list_domains
          request(
            expects:  200,
            method:   "GET",
            path:     "/#{@dnsimple_account}/domains"
          )
        end
      end

      class Mock
        def list_domains
          response = Excon::Response.new
          response.status = 200
          response.body = { "data" => self.data[:domains] }
          response
        end
      end
    end
  end
end
