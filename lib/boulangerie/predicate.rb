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
      @type.typecheck(value)
      @type.serialize(value)
    end
  end
end
