require "fog/core"
require "fog/json"

module Fog
  module DNS
    class Dnsimple < Fog::Service
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

          if options[:dnsimple_url]
            uri = URI.parse(options[:dnsimple_url])
            options[:host]    = uri.host
            options[:port]    = uri.port
            options[:scheme]  = uri.scheme
          end

          connection_options = options[:connection_options] || {}
          connection_options[:headers] ||= {}
          connection_options[:headers]["User-Agent"] = "#{Fog::Core::Connection.user_agents} fog-dnsimple/#{Fog::Dnsimple::VERSION}"

          host       = options[:host]        || "api.dnsimple.com"
          persistent = options[:persistent]  || false
          port       = options[:port]        || 443
          scheme     = options[:scheme]      || "https"
          @connection = Fog::Core::Connection.new("#{scheme}://#{host}:#{port}", persistent, connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}

          if @dnsimple_token && @dnsimple_account
            params[:headers].merge!("Authorization" => "Bearer #{@dnsimple_token}")
          else
            raise ArgumentError.new("Insufficient credentials to properly authenticate!")
          end
          params[:headers].merge!(
              "Accept" => "application/json",
              "Content-Type" => "application/json"
          )

          version = params.delete(:version) || "v2"
          params[:path] = File.join("/", version, params[:path])

          response = @connection.request(params)

          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        private

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
end
