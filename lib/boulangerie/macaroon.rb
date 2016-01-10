class Boulangerie
  # Wrapper for Macaroons from the 'macaroon' gem
  class Macaroon
    extend Forwardable

    attr_reader :identifier

    def_delegators :@macaroon, :location, :signature, :serialize

    def initialize(key: nil, identifier: nil, location: nil)
      @identifier = identifier || fail(ArgumentError, "no identifier given")

      @macaroon = Macaroons::Macaroon.new(
        key:        key,
        identifier: identifier.to_str,
        location:   location
      )
    end

    def inspect
      "#<#{self.class}:0x#{object_id} #{@identifier.to_str}>"
    end

    def add_first_party_caveat(caveat_id, value)
      @macaroon.add_first_party_caveat("#{caveat_id}: #{value}")
    end
  end
end
