module Fog
  module Dnsimple
    class DNS
      class Real
        # Delete the record with the given ID for the given domain.
        #
        # ==== Parameters
        # * zone_name<~String> - zone name
        # * record_id<~String>
        def delete_record(zone_name, record_id)
          request { |client| client.zones.delete_zone_record(@dnsimple_account, zone_name, record_id) }
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
