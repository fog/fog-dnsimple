module Fog
  module DNS
    class Dnsimple
      class Real
        # Delete the given domain from your account. You may use
        # either the domain ID or the domain name.
        #
        # Please note that for domains which are registered with
        # DNSimple this will not delete the domain from the registry.
        #
        # ==== Parameters
        # * account_id<~String> - the account the domain belong to
        # * zone_name<~String> - zone name
        #
        def delete_domain(zone_name)
          request(
            expects:  204,
            method:   "DELETE",
            path:     "/#{@dnsimple_account}/domains/#{zone_name}"
          )
        end
      end

      class Mock
        def delete_domain(zone_name)
          self.data[:records].delete(zone_name)
          self.data[:domains].reject! { |domain| domain["id"] == zone_name || domain["name"] == zone_name }

          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
