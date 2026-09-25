require "fog/core"
require "dnsimple"

module Fog
  module Dnsimple
    class DNS < Fog::Service
      recognizes :dnsimple_token, :dnsimple_account, :dnsimple_url

      model_path 'fog/dnsimple/models/dns'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/dnsimple/requests/dns'
      request :list_domains
      request :list_all_domains
      request :create_domain
      request :get_domain
      request :delete_domain
      request :create_record
      request :list_records
      request :list_all_records
      request :update_record
      request :delete_record
      request :get_record

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
                domains: [],
                records: {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options = {})
          @dnsimple_token = options[:dnsimple_token]
        end

        def data
          self.class.data[@dnsimple_token]
        end

        def reset_data
          self.class.data.delete(@dnsimple_token)
        end
      end

      class Real
        def initialize(options = {})
          @dnsimple_token = options[:dnsimple_token]
          @dnsimple_account = options[:dnsimple_account]

          @client = ::Dnsimple::Client.new(
            access_token: @dnsimple_token,
            base_url: options[:dnsimple_url],
            user_agent: "#{Fog::Core::Connection.user_agents} fog-dnsimple/#{Fog::Dnsimple::VERSION}"
          )
        end

        private

        # Converts the dnsimple-ruby result and errors to Excon types.
        def request
          unless @dnsimple_token && @dnsimple_account
            raise ArgumentError.new("Insufficient credentials to properly authenticate!")
          end

          excon_response(yield(@client).http_response)
        rescue ::Dnsimple::RequestError => e
          raise Excon::Error.status_error({}, excon_response(e.http_response))
        rescue ::Dnsimple::AuthenticationFailed => e
          raise Excon::Error.status_error({}, Excon::Response.new(status: 401, body: { "message" => e.message }))
        end

        def excon_response(http_response)
          Excon::Response.new(
            status: http_response.code,
            headers: http_response.response.each_header.to_h,
            body: http_response.parsed_response || ""
          )
        end

        def paginate(query: {})
          current_page = 0
          total_pages = nil
          total_entries = nil
          collection = []
          response = nil

          begin
            current_page += 1
            current_query = query.merge({ page: current_page, per_page: 100 })

            response = yield(current_query)
            total_entries ||= response.body.dig("pagination", "total_entries")
            total_pages ||= response.body.dig("pagination", "total_pages")
            collection.concat(response.body["data"])
          end while current_page < total_pages

          total_entries == collection.size or
            raise(Fog::Errors::Error, "Expected `#{total_entries}`, fetched only `#{collection.size}`")

          response.body["data"] = collection
          response
        end
      end
    end
  end

  # Keeps the constant from the service::provider format for compatibility.
  DNS::Dnsimple = Dnsimple::DNS
end
