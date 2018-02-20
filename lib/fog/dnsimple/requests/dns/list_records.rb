module Fog
  module DNS
    class Dnsimple
      class Real
        # Get the paginated list of records for the specific zone.
        #
        # @see https://developer.dnsimple.com/v2/zones/records/#list
        # @see https://github.com/dnsimple/dnsimple-developer/tree/master/fixtures/v2/listZoneRecords
        #
        # @param  zone_name [String]
        # @param  query [Hash]
        # @return [Excon::Response]
        def list_records(zone_name, query: {})
          request(
            expects: 200,
            method: "GET",
            path: "/#{@dnsimple_account}/zones/#{zone_name}/records",
            query: query
          )
        end
      end

      class Mock
        def list_records(zone_name, query: {})
          page = query[:page] || 1
          per_page = query[:per_page] || 30

          response = Excon::Response.new
          response.status = 200
          response.body = {
              "data" => Array(self.data[:records][zone_name]),
              "pagination" => { "current_page" => page, "per_page" => per_page, "total_entries" => 60, "total_pages" => 2 }
          }
          response
        end
      end
    end
  end
end
