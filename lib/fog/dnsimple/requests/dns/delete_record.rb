module Fog
  module DNS
    class Dnsimple
      class Real
        # Delete the record with the given ID for the given domain.
        #
        # ==== Parameters
        # * account_id<~String> - the account the domain belongs to
        # * zone_name<~String> - zone name
        # * record_id<~String>
        def delete_record(account_id, zone_name, record_id)
          request(
            expects:  204,
            method:   "DELETE",
            path:     "/#{account_id}/zones/#{zone_name}/records/#{record_id}"
          )
        end
      end

      class Mock
        def delete_record(_account_id, zone_name, record_id)
          self.data[:records][zone_name].reject! { |record| record["data"]["id"] == record_id }

          response = Excon::Response.new
          response.status = 200
          response
        end
      end
    end
  end
end
