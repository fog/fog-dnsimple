module Fog
  module DNS
    class Dnsimple
      class Real
        # Gets record from given domain.
        #
        # ==== Parameters
        # * zone_name<~String> - zone name
        # * record_id<~String>
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * "data"<~Hash> The representation of the record.
        def get_record(zone_name, record_id)
          request(
            expects:  200,
            method:   "GET",
            path:     "/#{@dnsimple_account}/zones/#{zone_name}/records/#{record_id}"
          )
        end
      end

      class Mock
        def get_record(zone_name, record_id)
          response = Excon::Response.new

          if self.data[:records].key?(zone_name)
            payload = self.data[:records][zone_name].find { |record| record["id"] == record_id }

            if payload
              response.status = 200
              response.body = { "data" => payload }
            else
              # response.status = 404
              # response.body = { "message" => "Record `#{record_id}` not found" }
              raise Excon::Errors::NotFound, "Record `#{record_id}` not found"
            end
          else
            # response.status = 404
            # response.body = { "message" => "Domain `#{zone_name}` not found" }
            raise Excon::Errors::NotFound, "Domain `#{zone_name}` not found"
          end

          response
        end
      end
    end
  end
end
