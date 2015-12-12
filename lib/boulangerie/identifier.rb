class Boulangerie
  # A unique identifier per Macaroon incorporating key/schema info
  class Identifier
    # Character to use for delimiting sections of the identifier
    DELIMITER = ":"

    def initialize(nonce: SecureRandom.uuid, schema: nil, key_id: nil)
      @nonce          = nonce
      @schema_id      = schema.schema_id
      @schema_version = schema.current_version
      @key_id         = key_id
    end

    # Serialize identifier as a string
    def to_str
      [
        @nonce,
        @key_id,
        @schema_id + "@" + @schema_version.to_s
      ].join(DELIMITER)
    end
  end
end
