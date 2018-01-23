module Fog
  module DNS
    class Dnsimple
      class Real
        # Delete the record with the given ID for the given domain.
        #
        # ==== Parameters
        # * zone_name<~String> - zone name
        # * record_id<~String>
        def delete_record(zone_name, record_id)
          request(
            expects:  204,
            method:   "DELETE",
            path:     "/#{@dnsimple_account}/zones/#{zone_name}/records/#{record_id}"
          )
        end
      end

      class Mock
        def delete_record(zone_name, record_id)
          self.data[:records][zone_name].reject! { |record| record["id"] == record_id }

          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
