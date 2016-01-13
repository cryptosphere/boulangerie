class Boulangerie
  # A unique identifier per Macaroon incorporating key/schema info
  class Identifier
    # Labels allowed in identifier headers
    ALLOWED_LABELS = %w(v uuid kid sch iat)

    # Character to use for delimiting sections of the identifier
    DELIMITER = " "

    attr_reader :uuid, :schema_id, :schema_version, :key_id, :issued_at

    def self.parse(string)
      parts = {}

      ALLOWED_LABELS.zip(string.split(" ")).each do |label, part|
        fail SerializationError, "missing '#{label}' in identifier" unless part

        matches = part.match(/\A(?<label>[a-z]+):(?<value>.*)\z/)
        fail SerializationError, "bad identifier: #{part}" unless matches
        fail SerializationError, "missing '#{label}' in identifier" unless label == matches[:label]

        parts[matches[:label]] = matches[:value]
      end

      unless Integer(parts["v"], 10) == FORMAT_VERSION
        fail SerializationError, "bad version: #{parts['v'].inspect}"
      end

      schema = parts["sch"].match(/\A(?<id>[a-z0-9]{16})@(?<version>\d+)\z/)
      fail SerializationError, "bad schema identifier: #{parts['sch'].inspect}" unless schema

      new(
        uuid:           parts["uuid"],
        schema_id:      schema[:id],
        schema_version: Integer(schema[:version], 10),
        key_id:         parts["kid"],
        issued_at:      Time.iso8601(parts["iat"])
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
