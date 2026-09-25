module Fog
  module Dnsimple
    class DNS
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
          request { |client| client.zones.update_zone_record(@dnsimple_account, zone_name, record_id, options) }
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
