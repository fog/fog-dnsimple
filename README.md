# Fog::Dnsimple

[![CI](https://github.com/fog/fog-dnsimple/actions/workflows/ci.yml/badge.svg)](https://github.com/fog/fog-dnsimple/actions/workflows/ci.yml)

This library is the [DNSimple](https://dnsimple.com/) provider for [fog](https://github.com/fog/fog). It uses the [DNSimple API](https://developer.dnsimple.com/) through the [dnsimple-ruby](https://github.com/dnsimple/dnsimple-ruby) client.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "fog-dnsimple"
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install fog-dnsimple
```

## Usage

Initialize a `Fog::DNS` object using the DNSimple provider.

```ruby
dns = Fog::DNS.new(
  provider:         "DNSimple",
  dnsimple_token:   "YOUR_API_TOKEN",
  dnsimple_account: "YOUR_ACCOUNT_ID",
)
```

- `YOUR_API_TOKEN`: the API access token. You can create it from your account page: Account > Access Tokens > Account access tokens.
- `YOUR_ACCOUNT_ID`: the numeric account ID. It is the number after `/a` in the account URL. For instance, if the account page is `https://dnsimple.com/a/1234/domains`, the account ID is `1234`.

You can then use it like other fog DNS providers.

```ruby
zone = dns.zones.create(
  domain: "example.com"
)
record = zone.records.create(
  name: "foo",
  value: "1.2.3.4",
  type: "A"
)
```

The following options are also supported:

```ruby
dns = Fog::DNS.new(
  provider:           "DNSimple",
  dnsimple_token:     "YOUR_API_TOKEN",
  dnsimple_account:   "YOUR_ACCOUNT_ID",
  # A different base URL, for example the Sandbox URL
  dnsimple_url:       "https://api.sandbox.dnsimple.com",
  # An HTTP proxy
  connection_options: { proxy: "http://proxy.example.com:8080" },
)
```

## Contributing

1. Fork it (https://github.com/fog/fog-dnsimple/fork)
2. Create your feature branch (`git switch -c my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
