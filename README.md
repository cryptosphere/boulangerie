![Boulangerie](https://raw.githubusercontent.com/cryptosphere/boulangerie/master/boulangerie.png)
==============
[![Gem Version](https://badge.fury.io/rb/boulangerie.svg)](http://rubygems.org/gems/boulangerie)
[![Build Status](https://travis-ci.org/cryptosphere/boulangerie.svg)](https://travis-ci.org/cryptosphere/boulangerie)
[![Code Climate](https://codeclimate.com/github/cryptosphere/boulangerie/badges/gpa.svg)](https://codeclimate.com/github/cryptosphere/boulangerie)
[![Coverage Status](https://coveralls.io/repos/cryptosphere/boulangerie/badge.svg?branch=master&service=github)](https://coveralls.io/github/cryptosphere/boulangerie?branch=master)

Boulangerie is a Ruby gem for building authorization systems using the
[Macaroons](http://macaroons.io) bearer credential format.

This gem provides an opinionated, high-level interface designed to simplify
integration of Macaroons into any authorization scenario.

## What are Macaroons and why should I care?

Macaroons are a new bearer credential format
[originally developed at Google][Macaroons Paper],
then popularized by the [HyperDex] project, which
[uses Macaroons for authorization][HyperDex Macaroons].

They can be seen as a simpler yet more powerful alternative to other
bearer credential formats like [JWT]. Unlike most other bearer credential
formats, Macaroons bind credentials obtained by multiple parties together
cryptographically, allowing authorization decisions to be made by many
parties (3+) while eliminating the types of attacks that are typically
uses against other credential formats in these scenarios.

[Macaroons Paper]: http://research.google.com/pubs/pub41892.html
[HyperDex]: http://hyperdex.org/
[HyperDex Macaroons]: http://hyperdex.org/doc/latest/Authorization/
[JWT]: http://jwt.io/

## Installation

Add this line to your application's Gemfile:

```ruby
gem "boulangerie"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install boulangerie

## Usage

Boulangerie can be used with Rails or any other pure Ruby project which has
use for bearer credentials.

### Rails 4.1+

Add the following to `config/initializers/boulangerie.rb`:

```ruby
Boulangerie.setup(
  schema: Rails.root.join("config/boulangerie_schema.yml"),
  keys:   Rails.application.secrets.boulangerie_keys
  key_id: "key1"
)
```

You will also need to edit `config/secrets.yml` and add the following to
your respective environments (example given for development):

```yaml
development:
  secret_key_base: DEADBEEFDEADBEEFDEADBEEF[...]
  boulangerie_keys:
    key0: "1b942ba242e9d39ce838d03652091695eb1fef93d35d9454498ca970a8827e8f"
    key1: "7efc8f72d159ce31a4b2c8db6281bf8d91a2f2778d4d0062f80b977ea43a8ec4"
```

The `boulangerie_keys` hash contains a "keyring" of keys which can be used to
create or verify Macaroons.

To generate random keys, use the `Boulangerie::Keyring.generate_key` method,
which you can call from `irb` or `pry`:

```
[1] pry(main)> require 'boulangerie'
=> true
[2] pry(main)> Boulangerie::Keyring.generate_key
=> "1b942ba242e9d39ce838d03652091695eb1fef93d35d9454498ca970a8827e8f"
```

The names of the keys (e.g. `key0`, `key1`) are arbitrary, but all new Macaroons
will use the key whose ID was passed in as the `key_id` option to
`Boulangerie#initialize`. This allows for key rotation, i.e. periodically you can
add a new key, and Macaroons minted under an old key will still verify.

Rotating keys is good security practice and you should definitely take advantage of it.

You'll also need to create a `config/boulangerie_schema.yml` file that
contains the schema for your Macaroons. Here is a basic schema that will
add `time-before` and `time-after` timestamp assertions on your Macaroons:

```yaml
---
schema-id: ee6da70e5ba01fec
predicates:
  v0:
    time-before: DateTime
    time-after: DateTime
```

A `schema-id` is a 64-bit random number. This is used to identify a schema
uniquely within your system regardless of what you decide to name or rename
the schema file.

You can generate a schema ID via `irb` or `pry`:

```
[1] pry(main)> require 'boulangerie'
=> true
[2] pry(main)> Boulangerie::Schema.create_schema_id
=> "ee6da70e5ba01fec"
```

A schema-id can also be any 64-bit random number serialized as hex which
is unique to your app/infrastructure.

This schema includes two *caveats*: an expiration date and a creation time,
before which the Macaroon is not considered valid.
The predicate matchers for these particular caveats are built into
Boulangerie, but you can extend it with your own.

Finally, to actually use Macaroons to make authorization decisions, we need
to configure Boulangerie in a given controller:

```ruby
class MyController < ApplicationController
  authorize_with_boulangerie
end
```

### Non-Rails Usage

The usage is quite similar to the Rails example above, but we can ignore any
non-Rails specific elements.

## Supported Ruby Versions

This library supports and is tested against the following Ruby versions:

* Ruby (MRI) 2.0, 2.1, 2.2
* JRuby 9000

## Contributing

* Fork this repository on GitHub
* Make your changes and send us a pull request
* If we like them we'll merge them
* If we've accepted a patch, feel free to ask for commit access

## License

Copyright (c) 2015 Tony Arcieri. Distributed under the MIT License. See
LICENSE.txt for further details.
