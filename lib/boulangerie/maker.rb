module Boulangerie
  # An opinionated Macaroon generator which follows a preset recipe
  class Maker
    def initialize(options)
      case options[:schema]
      when Pathname, String
        @schema = Schema.new(YAML.load_file(options[:schema].to_s))
      when Hash
        @schema = Schema.new(options[:schema])
      else fail ArgumentError, "can't load schema from #{options[:schema].class}"
      end

      @schema.freeze

      fail ArgumentError, "no keys given" unless options[:keys]
      @keys = options[:keys].freeze

      unless options[:keys].keys.all? { |kid| kid.is_a?(String) }
        fail ArgumentError, "all key IDs must be strings"
      end

      @keys.each do |kid, value|
        kid.freeze
        value.freeze
      end

      @default_key_id = options[:key_id]
      @default_key_id.freeze
    end
  end
end
