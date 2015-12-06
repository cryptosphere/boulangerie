require "yaml"

class Boulangerie
  # Represents the schema of predicates in a Macaroon
  class Schema
    # Error parsing schema
    ParseError = Class.new(StandardError)

    attr_reader :schema_id, :versions

    # Create a Boulangerie::Schema from a String containing unparsed YAML
    def self.from_yaml(yaml)
      new YAML.load(yaml)
    end

    def initialize(schema)
      extra_keys = schema.keys - %w(schema-id predicates)
      fail ParseError, "unrecognized key in schema: #{extra_keys.first}" unless extra_keys.empty?

      @schema_id = schema["schema-id"]
      fail ParseError, "no schema-id present (must be 16-digit hex number)" unless @schema_id
      fail ParseError, "bad schema-id: #{@schema_id.inspect}" unless @schema_id.match(/\h{16}/)

      predicates = schema["predicates"]
      fail ParseError, "no predicates in schema" unless predicates

      @versions = {}
      predicates.each_with_index do |(version_name, predicates), index|
        version = version_name[/\Av(\d+)\z/, 1]
        fail ParseError, "malformed version identifier: #{version_name.inspect}" unless version

        version = Integer(version, 10)
        fail ParseError, "non-sequential version: #{version_name.inspect}" unless version == index

        # TODO: check types of predicates
        @versions[version] = predicates.freeze
      end

      @versions.freeze
    end
  end
end
