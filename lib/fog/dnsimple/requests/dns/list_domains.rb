module Fog
  module DNS
    class Dnsimple
      class Real
        # Get the paginated list of domains in the account.
        #
        # @see https://developer.dnsimple.com/v2/domains/#list
        # @see https://github.com/dnsimple/dnsimple-developer/tree/master/fixtures/v2/listDomains
        #
        # @param  query [Hash]
        # @return [Excon::Response]
        def list_domains(query: {})
          request(
            expects: 200,
            method: "GET",
            path: "/#{@dnsimple_account}/domains",
            query: query
          )
        end
      end

      class Mock
        def list_domains(query: {})
          page = query[:page] || 1
          per_page = query[:per_page] || 30

          response = Excon::Response.new
          response.status = 200
          response.body = {
              "data" => self.data[:domains],
              "pagination" => { "current_page" => page, "per_page" => per_page, "total_entries" => 60, "total_pages" => 2 }
          }
          response
        end
      end
    end
  end
end
