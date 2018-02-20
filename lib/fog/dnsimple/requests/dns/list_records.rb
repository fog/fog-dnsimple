module Fog
  module DNS
    class Dnsimple
      class Real
        # Get the list of records for the specific zone.
        #
        # ==== Parameters
        # * zone_name<~String> - zone name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * "data"<~Array>:
        #       * <~Hash> The representation of the record.
        def list_records(zone_name)
          request(
            expects:  200,
            method:   "GET",
            path:     "/#{@dnsimple_account}/zones/#{zone_name}/records"
          )
        end
      end

      class Mock
        def list_records(zone_name)
          response = Excon::Response.new
          response.status = 200
          response.body = {
              "data" => Array(self.data[:records][zone_name]),
              "pagination" => { "current_page" => 1, "per_page" => 30, "total_entries" => 60, "total_pages" => 2 }
          }
          response
        end
      end
    end
  end
end
