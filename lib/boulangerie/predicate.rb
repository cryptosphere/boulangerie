class Boulangerie
  # Restrictions on a Macaroon's authority
  class Predicate
    attr_reader :type

    def initialize(options)
      case options
      when String then @type = Type[options]
      else fail TypeError, "invalid predicate: #{options.inspect} (expecting String)"
      end
    end

    def serialize(value)
      unless @type.allowed_classes.any? { |klass| value.is_a?(klass) }
        fail TypeError, "can't serialize #{value.class} as a #{@type.type_name}"
      end

      @type.serialize(value)
    end
  end
end
