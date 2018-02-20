require 'test_helper'

class Fog::DNS::Dnsimple::DnsTest < Minitest::Test

  def generate_unique_domain
    # get time (with 1/100th of sec accuracy)
    # want unique domain name and if provider is fast, this can be called more than once per second
    time = (Time.now.to_f * 100).to_i
    "test-#{time}.com"
  end

  def test_all
    @domain = nil
    @domain_count = 0


    ## Get current domain count

    response = Fog::DNS[:dnsimple].list_domains
    assert_equal 200, response.status

    @domain_count = response.body["data"].size


    ## Create domain

    domain = generate_unique_domain
    response = Fog::DNS[:dnsimple].create_domain(domain)

    assert_equal 201, response.status
    @domain = response.body["data"]


    ## Get domain by id

    response = Fog::DNS[:dnsimple].get_domain(@domain["id"])
    assert_equal 200, response.status


    ## Create an A resource record"

    domain = @domain["name"]
    name = "www"
    type = "A"
    content = "1.2.3.4"
    response = Fog::DNS[:dnsimple].create_record(domain, name, type, content)

    assert_equal 201, response.status
    @record = response.body["data"]


    ## Create a MX record

    domain = @domain["name"]
    name = ""
    type = "MX"
    content = "mail.#{domain}"
    options = { "ttl" => 60, "priority" => 10 }
    response = Fog::DNS[:dnsimple].create_record(domain, name, type, content, options)

    # MX record creation returns 201
    assert_equal 201, response.status

    options.each do |key, value|
      # MX record has option #{key}
      assert_equal value, response.body["data"][key.to_s]

      # MX record is correct type
      assert_equal "MX", response.body["data"]["type"]
    end


    ## Get a record

    domain = @domain["name"]
    record_id = @record["id"]

    response = Fog::DNS[:dnsimple].get_record(domain, record_id)

    assert_equal 200, response.status
    assert_equal @record, response.body["data"]


    ## Update a record

    domain = @domain["name"]
    record_id = @record["id"]
    options = { "content" => "2.3.4.5", "ttl" => 600 }
    response = Fog::DNS[:dnsimple].update_record(domain, record_id, options)

    assert_equal 200, response.status


    ## List records

    response = Fog::DNS[:dnsimple].list_records(@domain["name"])
    assert_equal 200, response.status

    # list records returns all records for domain
    @records = response.body["data"]
    assert_equal 2, @records.reject { |record| record["system_record"] }.size


    ## Pagination

    response = Fog::DNS[:dnsimple].list_all_domains
    assert_equal 200, response.status

    response = Fog::DNS[:dnsimple].list_all_records(@domain["name"])
    assert_equal 200, response.status


    # Delete records

    domain = @domain["name"]

    result = true
    @records.each do |record|
      next if record["system_record"]
      response = Fog::DNS[:dnsimple].delete_record(domain, record["id"])
      if response.status != 204
        result = false
        break
      end
    end

    assert result


    # Delete domain

    response = Fog::DNS[:dnsimple].delete_domain(@domain["name"])
    assert_equal 204, response.status

  end

end
