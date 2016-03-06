class Boulangerie
  # Wrapper for Macaroons from the 'macaroon' gem
  class Macaroon
    extend Forwardable

    attr_reader :identifier, :raw_macaroon

    # NOTE: location is intentionally not exposed as it's malleable and
    # could lead to potential attacks if used in an authorization decision
    def_delegators :@raw_macaroon, :signature, :serialize

    def self.from_binary(serialized)
      raw_macaroon = Macaroons::RawMacaroon.from_binary(serialized: serialized)
      identifier   = Identifier.parse(raw_macaroon.identifier)

      new(raw_macaroon: raw_macaroon, identifier: identifier)
    end

    def initialize(key: nil, identifier: nil, location: nil, raw_macaroon: nil)
      @identifier = identifier || fail(ArgumentError, "no identifier given")

      @raw_macaroon = raw_macaroon || Macaroons::RawMacaroon.new(
        key:        key,
        identifier: identifier.to_str,
        location:   location
      )
    end

    def inspect
      "#<#{self.class}:0x#{object_id} #{@identifier.to_str}>"
    end

    def add_first_party_caveat(caveat_id, value)
      @raw_macaroon.add_first_party_caveat("#{caveat_id}: #{value}")
    end
  end
end
