module Fog
  module DNS
    class Dnsimple
      class Real
        # Get the list of records for the specific domain.
        #
        # ==== Parameters
        # * account_id<~String> - the account the domain belongs to
        # * zone_name<~String> - zone name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * <~Array>:
        #       * "data"<~Hash> The representation of the record.
        def list_records(account_id, zone_name)
          request(
            expects:  200,
            method:   "GET",
            path:     "/#{account_id}/zones/#{zone_name}/records"
          )
        end
      end

      class Mock
        def list_records(_account_id, zone_name)
          response = Excon::Response.new
          response.status = 200
          response.body = self.data[:records][zone_name] || []
          response
        end
      end
    end
  end
end
