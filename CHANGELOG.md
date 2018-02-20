# Changelog


#### Release 2.1.0

- NEW: Added ability to fetch all (non-paginated) domains and records (GH-4, GH-6)

- FIXED: Added missing "minimum Ruby version" in Gemspec

- CHANGED: Replaced Shindo with Minitest (GH-5)


#### Release 2.0.0

Upgrade to DNSimple API v2.
https://developer.dnsimple.com/v2/

In order to use API v2 you need an API v2 Oauth token, and the accound ID. The account ID is the ID visible in the URL of the page, after /a.

    https://dnsimple.com/a/1234/domains/example.com
    -> 1234


#### Release 1.0.0

Initial version, extracted from `fog`.
