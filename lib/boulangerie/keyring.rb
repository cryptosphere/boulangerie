class Boulangerie
  # Stores keys to be used for minting and verifying Macaroons
  class Keyring
    def initialize(keys, key_id: nil)
      fail TypeError, "expected Hash, got #{keys.class}" unless keys.is_a? Hash

      # TODO: verify strength of keys
      @keys = keys.freeze

      @default_key_id = key_id
    end

    def inspect
      "#<#{self.class}:0x#{object_id} (key IDs: #{@keys.keys.join(', ')})>"
    end
  end
end
