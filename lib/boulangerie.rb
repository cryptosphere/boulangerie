# stdlib stuff
require "securerandom"
require "yaml"
require "time"
require "uri"

# External gems
require "rbnacl/libsodium"
require "macaroons"

require "boulangerie/version"

# Boulangerie Classes
require "boulangerie/identifier"
require "boulangerie/keyring"
require "boulangerie/predicate"
require "boulangerie/schema"
require "boulangerie/type"

# Boulangerie Types
require "boulangerie/type/list"

require "boulangerie/type/binary"
require "boulangerie/type/boolean"
require "boulangerie/type/date_time"
require "boulangerie/type/decimal"
require "boulangerie/type/label"
require "boulangerie/type/uri"

# An opinionated library for creating and verifying Macaroons in Ruby
class Boulangerie
  attr_reader :schema

  # Version of the format used
  FORMAT_VERSION = 0

  # Raised if Boulangerie's global maker hasn't been configured
  NotConfiguredError = Class.new(StandardError)

  # Caveats are invalid
  InvalidCaveatError = Class.new(StandardError)

  # Problems with serialization/deserialization
  SerializationError = Class.new(StandardError)

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

  # Creates a "golden macaroon" with no caveats
  # WARNING: This bypasses the security benefits Boulangerie ordinarily
  # provides. Make sure you know what you're doing!
  #
  # @return [Macaroon] a new golden Macaroon object with no caveats
  def golden_macaroon!
    identifier = Identifier.new(schema: @schema, key_id: @keyring.default_key_id)

    Macaroon.new(
      key:        @keyring.default_key,
      identifier: identifier.to_str,
      location:   @location
    )
  end

  # Creates a new Macaroon object from the given caveats
  #
  # @param [Hash] :caveats to include in the generated Macaroon
  #
  # @return [Macaroon] a new Macaroon object from the macaroons gem
  def create_macaroon(caveats: {})
    unspecified_predicates = @schema.predicates.keys - caveats.keys

    unless unspecified_predicates.empty?
      fail InvalidCaveatError, "no caveat specified for #{unspecified_predicates.first}"
    end

    golden_macaroon!.tap do |macaroon|
      caveats.each do |id, caveat|
        predicate = @schema.predicates[id]
        fail InvalidCaveatError, "no predicate in schema for: #{id.inspect}" unless predicate

        macaroon.add_first_party_caveat("#{id}: #{predicate.serialize(caveat)}")
      end
    end
  end

  # Creates a serialized macaroon as a String for use in a cookie
  #
  # @param [Hash] :caveats to pass to #create_macaroon
  #
  # @return [String] a serialized Macaroon that can be used as a cookie
  def bake(**args)
    create_macaroon(**args).serialize
  end
end
