require 'fog/core/collection'
require 'fog/dnsimple/models/dns/record'

module Fog
  module DNS
    class Dnsimple
      class Records < Fog::Collection
        attribute :zone

        model Fog::DNS::Dnsimple::Record

        def all
          requires :zone
          clear
          data = service.list_records(zone.id).body["data"]
          load(data)
        end

        def get(record_id)
          requires :zone
          data = service.get_record(zone.id, record_id).body["data"]
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

        def new(attributes = {})
          requires :zone
          super({ zone: zone }.merge!(attributes))
        end
      end
    end
  end
end
