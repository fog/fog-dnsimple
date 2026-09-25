require 'test_helper'
require 'webmock/minitest'

class Fog::Dnsimple::DNS::RealTest < Minitest::Test

  API_URL = "https://api.dnsimple.com"

  def setup
    @service = Fog::Dnsimple::DNS::Real.new(dnsimple_token: "token", dnsimple_account: "1010")
  end

  def account_url(path, base_url: API_URL)
    "#{base_url}/v2/1010#{path}"
  end

  def stub_api(method, path, status: 200, body: nil, query: nil, base_url: API_URL)
    stub = stub_request(method, account_url(path, base_url: base_url))
    stub = stub.with(query: query) if query
    stub.to_return(
      status: status,
      headers: { "Content-Type" => "application/json" },
      body: body ? JSON.dump(body) : ""
    )
  end

  def test_get_domain
    stub_api(:get, "/domains/example.com", body: { "data" => { "id" => 1, "name" => "example.com" } })

    response = @service.get_domain("example.com")

    assert_kind_of Excon::Response, response
    assert_equal 200, response.status
    assert_equal({ "id" => 1, "name" => "example.com" }, response.body["data"])
    assert_requested :get, account_url("/domains/example.com"),
                     headers: { "Authorization" => "Bearer token", "User-Agent" => /fog-dnsimple\/#{Fog::Dnsimple::VERSION}/ }
  end

  def test_get_domain_not_found
    stub_api(:get, "/domains/example.com", status: 404, body: { "message" => "Domain `example.com` not found" })

    assert_raises(Excon::Error::NotFound) { @service.get_domain("example.com") }
  end

  def test_request_unauthorized
    stub_api(:get, "/domains/example.com", status: 401, body: { "message" => "Authentication failed" })

    assert_raises(Excon::Error::Unauthorized) { @service.get_domain("example.com") }
  end

  def test_request_timeout
    stub_request(:get, account_url("/domains/example.com")).to_timeout

    assert_raises(Excon::Error::Timeout) { @service.get_domain("example.com") }
  end

  def test_request_socket_error
    stub_request(:get, account_url("/domains/example.com")).to_raise(Errno::ECONNREFUSED)

    assert_raises(Excon::Error::Socket) { @service.get_domain("example.com") }
  end

  def test_proxy
    [
      "http://proxy.example.com:8080",
      { host: "proxy.example.com", port: 8080 },
    ].each do |proxy|
      service = Fog::Dnsimple::DNS::Real.new(dnsimple_token: "token", dnsimple_account: "1010", connection_options: { proxy: proxy })

      assert_equal "proxy.example.com:8080", service.instance_variable_get(:@client).proxy
    end
  end

  def test_request_without_account
    service = Fog::Dnsimple::DNS::Real.new(dnsimple_token: "token")

    assert_raises(ArgumentError) { service.get_domain("example.com") }
  end

  def test_delete_domain
    stub_api(:delete, "/domains/example.com", status: 204)

    response = @service.delete_domain("example.com")

    assert_equal 204, response.status
    assert_equal "", response.body
  end

  def test_create_record
    stub_api(:post, "/zones/example.com/records", status: 201, body: { "data" => { "id" => 5, "name" => "www" } })

    response = @service.create_record("example.com", "www", "A", "1.2.3.4", ttl: 60)

    assert_equal 201, response.status
    assert_equal 5, response.body["data"]["id"]
    assert_requested :post, account_url("/zones/example.com/records"),
                     body: { "name" => "www", "type" => "A", "content" => "1.2.3.4", "ttl" => 60 }
  end

  def test_list_all_records
    2.times do |index|
      page = index + 1
      stub_api(:get, "/zones/example.com/records",
               query: { "page" => page.to_s, "per_page" => "100" },
               body: {
                 "data" => [{ "id" => page }],
                 "pagination" => { "current_page" => page, "per_page" => 100, "total_entries" => 2, "total_pages" => 2 }
               })
    end

    response = @service.list_all_records("example.com")

    assert_equal [{ "id" => 1 }, { "id" => 2 }], response.body["data"]
  end

  def test_dnsimple_url
    sandbox_url = "https://api.sandbox.dnsimple.com"
    service = Fog::Dnsimple::DNS::Real.new(dnsimple_token: "token", dnsimple_account: "1010", dnsimple_url: sandbox_url)
    stub_api(:get, "/domains/example.com", body: { "data" => {} }, base_url: sandbox_url)

    assert_equal 200, service.get_domain("example.com").status
  end

end
