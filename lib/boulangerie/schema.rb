require "yaml"
require "securerandom"

class Boulangerie
  # Represents the schema of predicates in a Macaroon
  class Schema
    # Built-in types supported by Boulangerie
    BUILT_IN_TYPES = %w(
      DateTime
      Binary
      String
      Boolean
    )

    # Error parsing schema
    ParseError = Class.new(StandardError)

    # Schema ID omitted/invalid
    InvalidSchemaIdError = Class.new(ParseError)

    # Schema version invalid
    InvalidVersionError = Class.new(ParseError)

    # Invalid type specification
    InvalidTypeError = Class.new(ParseError)

    attr_reader :schema_id, :versions

    def self.create_schema_id
      SecureRandom.hex(8)
    end

    # Create a Boulangerie::Schema from a String containing unparsed YAML
    def self.from_yaml(yaml)
      new YAML.load(yaml)
    end

    def initialize(schema)
      extra_keys = schema.keys - %w(schema-id predicates)
      fail ParseError, "unrecognized key in schema: #{extra_keys.first}" unless extra_keys.empty?

      @schema_id = schema["schema-id"]
      fail InvalidSchemaIdError, "no schema-id present (must be 16-digit hex number)" unless @schema_id
      fail InvalidSchemaIdError, "bad schema-id: #{@schema_id.inspect}" unless @schema_id.match(/\h{16}/)

      predicate_versions = schema["predicates"]
      fail ParseError, "no predicates in schema" unless predicate_versions

      @versions = predicate_versions.map.with_index do |(version_name, predicates), index|
        version = version_name[/\Av(\d+)\z/, 1]
        fail InvalidVersionError, "malformed version identifier: #{version_name.inspect}" unless version

        version = Integer(version, 10)
        fail InvalidVersionError, "non-sequential version: #{version_name.inspect}" unless version == index

        parsed_predicates = predicates.map { |id, options| [id, parse_predicate(options)] }
        Hash[parsed_predicates].freeze
      end

      @versions.freeze
    end

    private

    # Parse a predicate entry, extracting type information
    def parse_predicate(options)
      predicate = {}

      case options
      when String then predicate[:type] = options.freeze
      else fail TypeError, "invalid predicate: #{options.inspect} (expecting String)"
      end

      unless BUILT_IN_TYPES.include?(predicate[:type])
        fail InvalidTypeError, "invalid type: #{predicate[:type].inspect}"
      end

      predicate.freeze
    end
  end
end
