module Fog
  module DNS
    class Dnsimple
      class Real
        # Gets record from given domain.
        #
        # ==== Parameters
        # * account_id<~String> - the account the domain belongs to
        # * zone_name<~String> - zone name
        # * record_id<~String>
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * "data"<~Hash> The representation of the record.
        def get_record(account_id, zone_name, record_id)
          request(
            expects:  200,
            method:   "GET",
            path:     "/#{account_id}/zones/#{zone_name}/records/#{record_id}"
          )
        end
      end

      class Mock
        def get_record(_account_id, zone_name, record_id)
          response = Excon::Response.new

          if self.data[:records].key?(zone_name)
            response.status = 200
            response.body = self.data[:records][zone_name].find { |record| record["data"]["id"] == record_id }

            if response.body.nil?
              response.status = 404
              response.body = {
                "error" => "Couldn't find Record with id = #{record_id}"
              }
            end
          else
            response.status = 404
            response.body = {
              "error" => "Couldn't find Domain with name = #{zone_name}"
            }
          end
          response
        end
      end
    end
  end
end
