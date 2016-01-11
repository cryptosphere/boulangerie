class Boulangerie
  # A unique identifier per Macaroon incorporating key/schema info
  class Identifier
    # Character to use for delimiting sections of the identifier
    DELIMITER = " "

    attr_reader :uuid, :schema_id, :schema_version, :key_id, :issued_at

    def self.parse(string)
      version        = nil
      uuid           = nil
      schema_id      = nil
      schema_version = nil
      key_id         = nil
      issued_at      = nil

      string.split(" ").each do |part|
        matches = part.match(/\A([a-z]+):(.*)\z/)
        fail SerializationError, "bad identifier: #{part}" unless matches

        label = matches[1]
        value = matches[2]

        case label
        when "v"    then version   = Integer(value, 10)
        when "uuid" then uuid      = value
        when "kid"  then key_id    = value
        when "iat"  then issued_at = Time.iso8601(value)
        when "sch"
          matches = value.match(/\A([a-z0-9]+)@(\d+)\z/)
          fail SerializationError, "bad schema identifier: #{value}" unless matches

          schema_id      = matches[1]
          schema_version = Integer(matches[2], 10)
        else fail SerializationError, "unknown identifier: #{label}"
        end
      end

      fail SerializationError, "bad version: #{version.inspect}" unless version == FORMAT_VERSION

      new(
        uuid:           uuid           || fail(SerializationError, "no uuid in identifier"),
        schema_id:      schema_id      || fail(SerializationError, "no sch in identifier"),
        schema_version: schema_version || fail(SerializationError, "no sch in identifier"),
        key_id:         key_id         || fail(SerializationError, "no kid in identifier"),
        issued_at:      issued_at      || fail(SerializationError, "no iat in identifier")
      )
    end

    def initialize(uuid: nil, schema_id: nil, schema_version: nil, key_id: nil, issued_at: Time.now)
      @uuid           = uuid || SecureRandom.uuid
      @schema_id      = schema_id
      @schema_version = schema_version
      @key_id         = key_id
      @issued_at      = issued_at.utc
    end

    # Serialize identifier as a string
    def to_str
      [
        "v:#{Boulangerie::FORMAT_VERSION}",
        "uuid:#{@uuid}",
        "kid:#{@key_id}",
        "sch:#{@schema_id}@#{@schema_version}",
        "iat:#{@issued_at.iso8601}"
      ].join(DELIMITER)
    end
  end
end
