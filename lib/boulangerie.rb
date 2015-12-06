require "boulangerie/version"

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

  def initialize(schema: nil, keys: nil, key_id: nil)
    @schema =
      case schema
      when Schema           then schema
      when String, Pathname then Schema.from_yaml(File.read(schema.to_s))
      else fail TypeError,  "bad schema type: #{schema.class}"
      end

    @keyring = Keyring.new(keys, key_id: key_id)
  end
end
