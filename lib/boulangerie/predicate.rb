class Boulangerie
  # Restrictions on a Macaroon's authority
  class Predicate
    attr_reader :type

    # Built-in types supported by Boulangerie
    BUILT_IN_TYPES = %w(
      DateTime
      Binary
      String
      Boolean
    )

    def initialize(options)
      case options
      when String then @type = options.freeze
      else fail TypeError, "invalid predicate: #{options.inspect} (expecting String)"
      end

      fail TypeError, "bad predicate type: #{@type.inspect}" unless BUILT_IN_TYPES.include?(@type)
    end

    def serialize(value)
      value.to_s
    end
  end
end
