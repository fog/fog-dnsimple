# Fog::Dnsimple

[![Build Status](https://travis-ci.org/fog/fog-dnsimple.svg?branch=master)](https://travis-ci.org/fog/fog-dnsimple)


## API Version

This library currently uses the [DNSimple API v2](https://developer.dnsimple.com/v2/) 
and it is compatible with the legacy implementation bundled with the `fog` gem.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fog-dnsimple'
```

And then execute:

```
bundle
```

Or install it yourself as:

```
gem install fog-dnsimple
```


## Usage

Initialize a `Fog::DNS` object using the DNSimple provider.

```ruby
dns = Fog::DNS.new({
  provider:         "DNSimple",
  dnsimple_token:   "YOUR_API_TOKEN",
  dnsimple_account: "YOUR_ACCOUNT_ID",
})
```

- `YOUR_API_TOKEN`: This is the API v2 access token. You can create it from your account page: Account > Access Tokens > Account access tokens.
- `YOUR_ACCOUNT_ID`: This is the account ID. We currently support only the numeric ID (account string identifiers will be supported in the future). The account ID is the numeric ID after the `/a` in the path prefix. For instance, if the account page is `https://dnsimple.com/a/1234/domains`, the account ID is `1234`.

This can then be used like other [Fog DNS](http://fog.io/dns/) providers.

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

The following configurations are supported:

```ruby
dns = Fog::DNS.new({
  # Use dnsimple_url to provide a different base URL, e.g. the Sandbox URL
  dnsimple_url:   "https://api.sandbox.dnsimple.com/",
})
```

## Contributing

1. Fork it ( https://github.com/fog/fog-dnsimple/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
