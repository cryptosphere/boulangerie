class Boulangerie
  # A unique identifier per Macaroon incorporating key/schema info
  class Identifier
    # Character to use for delimiting sections of the identifier
    DELIMITER = " "

    def initialize(nonce: SecureRandom.uuid, schema: nil, key_id: nil, issued_at: Time.now)
      @nonce     = nonce
      @schema    = schema
      @key_id    = key_id
      @issued_at = issued_at.utc
    end

    # Serialize identifier as a string
    def to_str
      [
        "v:#{Boulangerie::FORMAT_VERSION}",
        "uuid:#{@nonce}",
        "kid:#{@key_id}",
        "sch:#{@schema.identifier}",
        "iat:#{@issued_at.iso8601}"
      ].join(DELIMITER)
    end
  end
end
