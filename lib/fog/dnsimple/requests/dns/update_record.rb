module Fog
  module DNS
    class Dnsimple
      class Real
        # Update the given record for the given domain.
        #
        # ==== Parameters
        # * zone_name<~String> - zone name
        # * record_id<~String>
        # * options<~Hash> - optional
        #   * type<~String>
        #   * content<~String>
        #   * priority<~Integer>
        #   * ttl<~Integer>
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * "data"<~Hash> The representation of the record.
        def update_record(zone_name, record_id, options)
          body = options

          request(
            body:     Fog::JSON.encode(body),
            expects:  200,
            method:   "PATCH",
            path:     "/#{@dnsimple_account}/zones/#{zone_name}/records/#{record_id}"
          )
        end
      end

      class Mock
        def update_record(zone_name, record_id, options)
          record = self.data[:records][zone_name].find { |record| record["id"] == record_id }
          response = Excon::Response.new

          if record.nil?
            response.status = 400
          else
            response.status = 200
            record.merge!(options)
            record["updated_at"] = Time.now.iso8601
            response.body = { "data" => record }
          end

          response
        end
      end
    end
  end
end
