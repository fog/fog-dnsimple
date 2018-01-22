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
        # * domain_id<~String> - domain name or numeric ID
        #
        def delete_domain(account_id, domain_id)
          request(
            expects:  204,
            method:   "DELETE",
            path:     "/#{account_id}/domains/#{domain_id}"
          )
        end
      end

      class Mock
        def delete_domain(_account_id, domain_id)
          self.data[:records].delete(domain_id)
          self.data[:domains].reject! { |domain| domain["data"]["name"] == domain_id }

          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
