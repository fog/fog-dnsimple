module Fog
  module DNS
    class Dnsimple
      class Real
        # Create a new host in the specified zone
        #
        # ==== Parameters
        # * zone_name<~String> - zone name
        # * name<~String>
        # * type<~String>
        # * content<~String>
        # * options<~Hash> - optional
        #   * priority<~Integer>
        #   * ttl<~Integer>
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'record'<~Hash> The representation of the record.
        def create_record(zone_name, name, type, content, options = {})
          body = {
            "name" => name,
            "type" => type,
            "content" => content
          }
          body.merge!(options)

          request(
            body:     Fog::JSON.encode(body),
            expects:  201,
            method:   "POST",
            path:     "/#{@dnsimple_account}/zones/#{zone_name}/records"
          )
        end
      end

      class Mock
        def create_record(zone_name, name, type, content, options = {})
          body = {
            "id" => Fog::Mock.random_numbers(1).to_i,
            "domain_id" => 1,
            "name" => name,
            "content" => content,
            "ttl" => 3600,
            "priority" => 0,
            "type" => type,
            "system_record" => false,
            "created_at" => Time.now.iso8601,
            "updated_at" => Time.now.iso8601,
          }.merge(options)
          self.data[:records][zone_name] ||= []
          self.data[:records][zone_name] << body

          response = Excon::Response.new
          response.status = 201
          response.body = { "data" => body }
          response
        end
      end
    end
  end
end
