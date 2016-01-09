class Boulangerie
  # A unique identifier per Macaroon incorporating key/schema info
  class Identifier
    # Character to use for delimiting sections of the identifier
    DELIMITER = " "

    def initialize(nonce: SecureRandom.uuid, schema: nil, key_id: nil, issued_at: Time.now.utc)
      @nonce          = nonce
      @schema_id      = schema.schema_id
      @schema_version = schema.current_version
      @key_id         = key_id
      @issued_at      = issued_at
    end

    # Serialize identifier as a string
    def to_str
      [
        "v:#{Boulangerie::FORMAT_VERSION}",
        "uuid:#{@nonce}",
        "kid:#{@key_id}",
        "sch:#{@schema_id}@#{@schema_version}",
        "iat:#{@issued_at.iso8601}"
      ].join(DELIMITER)
    end
  end
end
