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

Coming soon!

## Supported Ruby Versions

This library supports and is tested against the following Ruby versions:

* Ruby (MRI) 2.0, 2.1, 2.2
* JRuby 9000

## Contributing

* Fork this repository on github
* Make your changes and send us a pull request
* If we like them we'll merge them
* If we've accepted a patch, feel free to ask for commit access

## License

Copyright (c) 2015 Tony Arcieri. Distributed under the MIT License. See
LICENSE.txt for further details.
