class Boulangerie
  # Represents the schema of predicates in a Macaroon
  class Schema
    # Toplevel keys allowed in the schema
    VALID_TOPLEVEL_KEYS = %w(
      schema-id
      predicates
    )

    # Error parsing schema
    ParseError = Class.new(StandardError)

    # Schema ID omitted/invalid
    InvalidSchemaIdError = Class.new(ParseError)

    # Schema version invalid
    InvalidVersionError = Class.new(ParseError)

    attr_reader :schema_id, :predicates

    def self.create_schema_id
      SecureRandom.hex(8)
    end

    # Create a Boulangerie::Schema from a String containing unparsed YAML
    def self.from_yaml(yaml)
      new YAML.load(yaml)
    end

    def initialize(schema)
      unless (extra_keys = schema.keys - VALID_TOPLEVEL_KEYS).empty?
        fail ParseError, "unrecognized key in schema: #{extra_keys.first}"
      end

      @schema_id = schema["schema-id"]
      fail InvalidSchemaIdError, "no schema-id present" unless @schema_id
      fail InvalidSchemaIdError, "bad schema-id: #{@schema_id}" unless @schema_id.match(/\h{16}/)

      predicate_versions = Array(schema["predicates"])
      fail ParseError, "no predicates in schema" if predicate_versions.empty?

      @predicates = {}
      @versions = predicate_versions.map.with_index do |(version_name, predicates), index|
        unless (version = version_name[/\Av(\d+)\z/, 1])
          fail InvalidVersionError, "malformed version identifier: #{version_name.inspect}"
        end

        version = Integer(version, 10)
        fail InvalidVersionError, "non-sequential version: #{version}" unless version == index

        version_predicates = {}
        predicates.each do |id, options|
          fail ParseError, "predicate #{id} specified twice" if @predicates.key?(id)
          predicate = Predicate.new(options).freeze

          @predicates[id.freeze] = predicate
          version_predicates[id] = predicate
        end

        version_predicates.freeze
      end.freeze

      @predicates.freeze
    end

    # What is the current version of the loaded schema?
    def current_version
      @versions.count - 1
    end
  end
end
