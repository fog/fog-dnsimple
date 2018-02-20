Shindo.tests('Fog::DNS[:dnsimple] | DNS requests', ["dnsimple", "dns"]) do

  def generate_unique_domain
    # get time (with 1/100th of sec accuracy)
    # want unique domain name and if provider is fast, this can be called more than once per second
    time = (Time.now.to_f * 100).to_i
    "test-#{time}.com"
  end

  @domain = nil
  @domain_count = 0

  tests("success") do

    test("get current domain count") do
      response = Fog::DNS[:dnsimple].list_domains
      if response.status == 200
        @domain_count = response.body["data"].size
      end

      response.status == 200
    end

    test("create domain") do
      domain = generate_unique_domain
      response = Fog::DNS[:dnsimple].create_domain(domain)
      if response.status == 201
        @domain = response.body["data"]
      end

      response.status == 201
    end

    test("get domain by id") do
      response = Fog::DNS[:dnsimple].get_domain(@domain["id"])
      response.status == 200
    end

    test("create an A resource record") do
      domain = @domain["name"]
      name = "www"
      type = "A"
      content = "1.2.3.4"
      response = Fog::DNS[:dnsimple].create_record(domain, name, type, content)

      if response.status == 201
        @record = response.body["data"]
      end

      response.status == 201

    end

    test("create a MX record") do
      domain = @domain["name"]
      name = ""
      type = "MX"
      content = "mail.#{domain}"
      options = { "ttl" => 60, "priority" => 10 }
      response = Fog::DNS[:dnsimple].create_record(domain, name, type, content, options)

      test "MX record creation returns 201" do
        response.status == 201
      end

      options.each do |key, value|
        test("MX record has option #{key}") { value == response.body["data"][key.to_s] }
      end

      test "MX record is correct type" do
        response.body["data"]["type"] == "MX"
      end
    end

    test("get a record") do
      domain = @domain["name"]
      record_id = @record["id"]

      response = Fog::DNS[:dnsimple].get_record(domain, record_id)

      (response.status == 200) and (@record == response.body["data"])
    end

    test("update a record") do
      domain = @domain["name"]
      record_id = @record["id"]
      options = { "content" => "2.3.4.5", "ttl" => 600 }
      response = Fog::DNS[:dnsimple].update_record(domain, record_id, options)
      response.status == 200
    end

    test("list records") do
      response = Fog::DNS[:dnsimple].list_records(@domain["name"])

      if response.status == 200
        @records = response.body["data"]
      end

      test "list records returns all records for domain" do
        @records.reject { |record| record["system_record"] }.size == 2
      end

      response.status == 200
    end

    test("delete records") do
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

      result
    end

    test("delete domain") do
      response = Fog::DNS[:dnsimple].delete_domain(@domain["name"])
      response.status == 204
    end
  end

end
