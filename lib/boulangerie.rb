require "securerandom"
require "yaml"

require "rbnacl/libsodium"
require "macaroons"

require "boulangerie/version"

require "boulangerie/identifier"
require "boulangerie/keyring"
require "boulangerie/schema"

# An opinionated library for creating and verifying Macaroons in Ruby
class Boulangerie
  attr_reader :schema

  # Raised if Boulangerie's global maker hasn't been configured
  NotConfiguredError = Class.new(StandardError)

  # Default Boulangerie
  @default = nil

  def self.setup(**args)
    @default = new(**args)
  end

  def self.default
    fail NotConfiguredError, "not configured yet, call #{self}.setup" unless @default
    @default
  end

  def self.bake(**args)
    default.bake(**args)
  end

  def initialize(schema: nil, keys: nil, key_id: nil, location: nil)
    @schema =
      case schema
      when Schema           then schema
      when String, Pathname then Schema.from_yaml(File.read(schema.to_s))
      else fail TypeError,  "bad schema type: #{schema.class}"
      end

    @keyring  = Keyring.new(keys, key_id: key_id)
    @location = location || fail(ArgumentError, "no location given")
  end

  # Creates a new Macaroon object from the given caveats
  #
  # @param [Hash] caveats to include in the generated Macaroon
  # @return [Macaroon] a new Macaroon object from the macaroons gem
  def create_macaroon(caveats = {})
    identifier = Identifier.new(schema: @schema, key_id: @keyring.default_key_id)

    macaroon = Macaroon.new(
      key:        @keyring.default_key,
      identifier: identifier.to_str,
      location:   @location
    )

    caveats.each do |id, predicate|
      # TODO: verify caveat ID in schema
      # TODO: proper type serialization
      macaroon.add_first_party_caveat("#{id} #{predicate}")
    end

    macaroon
  end

  # Creates a serialized macaroon as a String for use in a cookie
  #
  # @param [Hash] caveats to pass to #create_macaroon
  # @return [String] a serialized Macaroon that can be used as a cookie
  def bake(caveats = {})
    create_macaroon(caveats).serialize
  end
end
