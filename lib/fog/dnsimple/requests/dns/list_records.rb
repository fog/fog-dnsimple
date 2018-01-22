module Fog
  module DNS
    class Dnsimple
      class Real
        # Get the list of records for the specific domain.
        #
        # ==== Parameters
        # * zone_name<~String> - zone name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * <~Array>:
        #       * "data"<~Hash> The representation of the record.
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
          response.body = self.data[:records][zone_name] || []
          response
        end
      end
    end
  end
end
