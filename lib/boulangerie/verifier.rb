class Boulangerie
  # Verify authenticity of Macaroons and whether caveats hold
  class Verifier
    def initialize(schema: nil, matchers: {})
      @schema   = schema
      @matchers = matchers

      # Add default matchers
      @matchers["expires"]    ||= Matcher::Expires.new.freeze
      @matchers["not-before"] ||= Matcher::NotBefore.new.freeze

      unless (missing_matchers = @schema.predicates.keys - @matchers.keys).empty?
        fail ArgumentError, "no matcher defined for: #{missing_matchers.first}"
      end

      @matchers.freeze
    end

    def verify(key: nil, macaroon: nil, discharge_macaroons: [], context: nil)
      fail ArgumentError, "no key given" unless key

      unless macaroon.is_a?(Boulangerie::Macaroon)
        fail TypeError, "excpected Boulangerie::Macaroon, got #{macaroon.class}"
      end

      verifier = Macaroons::Verifier.new
      verifier.satisfy_general { |caveat| satisfy(caveat, context) }

      verifier.verify(
        key: key,
        macaroon: macaroon.raw_macaroon,
        discharge_macaroons: discharge_macaroons
      )
    end

    private

    def satisfy(caveat, context)
      regex_matches = caveat.match(%r{\A([0-9a-zA-Z\.\/\-_]+): (.*)\z})
      fail SerializationError, "couldn't parse caveat: #{caveat}" unless regex_matches

      predicate_id = regex_matches[1]
      value        = @schema.predicates.fetch(predicate_id).deserialize(regex_matches[2])
      matcher      = @matchers.fetch(predicate_id)

      matcher.call(value, context)
    end
  end
end
