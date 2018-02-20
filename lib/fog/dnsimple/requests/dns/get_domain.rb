module Fog
  module DNS
    class Dnsimple
      class Real
        # Get the details for a specific domain in your account. You
        # may pass either the domain numeric ID or the domain name
        # itself.
        #
        # ==== Parameters
        # * zone_name<~String> - zone name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * "data"<~Hash> The representation of the domain.
        def get_domain(zone_name)
          request(
            expects:  200,
            method:   "GET",
            path:     "/#{@dnsimple_account}/domains/#{zone_name}"
          )
        end
      end

      class Mock
        def get_domain(zone_name)
          response = Excon::Response.new

          payload = self.data[:domains].find { |domain| domain["id"] == zone_name || domain["name"] == zone_name }
          if payload
            response.status = 200
            response.body = { "data" => payload }
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
