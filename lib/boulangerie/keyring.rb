class Boulangerie
  # Stores keys to be used for minting and verifying Macaroons
  class Keyring
    # Size of a parsed key in bytes (256-bits)
    KEY_LENGTH = 32

    attr_reader :default_key_id

    def self.generate_key
      SecureRandom.hex(KEY_LENGTH)
    end

    def initialize(keys, key_id: nil)
      fail TypeError, "expected Hash, got #{keys.class}" unless keys.is_a? Hash
      fail ArgumentError, "key_id not in keyring: #{key_id.inspect}" unless keys.key?(key_id)

      keys.each do |id, key|
        fail ArgumentError, "malformatted key: #{id}" unless key.length == KEY_LENGTH * 2 # hex
      end

      @keys = keys.freeze
      @default_key_id = key_id.freeze
    end

    # Key of the keyring we should use for generating new Macaroons
    def default_key
      @keys[@default_key_id]
    end

    def inspect
      "#<#{self.class}:0x#{object_id} (key IDs: #{@keys.keys.join(', ')})>"
    end
  end
end
