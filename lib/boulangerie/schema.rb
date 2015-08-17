require "yaml"

module Boulangerie
  # Represents the schema of predicates in a Macaroon
  class Schema
    attr_reader :predicates

    # Create a Boulangerie::Schema from a String containing unparsed YAML
    def self.from_yaml(yaml)
      new YAML.load(yaml)
    end

    def initialize(predicates)
      @predicates = {}

      predicates.each do |name, options|
        class_name = options["class_name"]
        fail ArgumentError, "no class_name defined for #{name}" unless class_name

        predicate_class = Object.const_get(class_name)
        default_value = options["default_value"]

        @predicates[name] =
          if default_value
            predicate_class.new(default_value)
          else
            predicate_class.new
          end
      end

      @predicates.freeze
    end
  end
end
