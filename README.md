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

Macaroons are a new bearer credential format originally developed at Google,
then popularized by Robert Escriva of the [HyperDex] project, which
[uses Macaroons for authorization][HyperDex Macaroons]. They can be seen as
a simpler yet more powerful alternative to other bearer credential formats
like [JWT].

A more complete answer of why you should care coming soon!

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
  key_id: "k1"
)
```

You will also need to edit `config/secrets.yml` and add the following to
your respective environments (example given for development):

```yaml
development:
  secret_key_base: DEADBEEFDEADBEEFDEADBEEF[...]
  boulangerie_keys:
    key0: "place any random value here ideally at least 32 bytes of random hex"
    key1: "boulangerie supports key rotation so you can list more than one key"
```

The `boulangerie_keys` hash contains a "keyring" of keys which can be used to
create or verify Macaroons. The names of the keys (e.g. `key0`, `key1`) are
arbitrary, but all new Macaroons will use the key whose ID was passed in as
the `key_id` option to `Boulangerie::Maker#new`. This allows for key rotation,
i.e. periodically you can add a new key, and Macaroons minted under an old key
will still verify. This is good security practice and you should definitely
take advantage of it.

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

This defines a Macaroon schema which includes two *caveats*: an expiration
date and a creation time, before which the Macaroon is not considered valid.
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
