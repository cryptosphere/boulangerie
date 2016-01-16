class Boulangerie
  # A unique identifier per Macaroon incorporating key/schema info
  class Identifier
    # Labels allowed in identifier headers
    ALLOWED_LABELS = %w(v uuid kid sch iat)

    # Character to use for delimiting sections of the identifier
    DELIMITER = " "

    attr_reader :uuid, :schema_id, :schema_version, :key_id, :issued_at

    def self.parse(string)
      parts  = string.split(" ")
      fields = {}

      ALLOWED_LABELS.zip(parts).each do |label, part|
        fail SerializationError, "missing '#{label}' in identifier" unless part

        matches = part.match(/\A(?<label>[a-z]+):(?<value>.*)\z/)
        fail SerializationError, "bad identifier: #{part}" unless matches
        fail SerializationError, "missing '#{label}' in identifier" unless label == matches[:label]

        fields[matches[:label]] = matches[:value]
      end

      unless Integer(fields["v"], 10) == FORMAT_VERSION
        fail SerializationError, "bad version: #{fields['v'].inspect}"
      end

      if parts.size > ALLOWED_LABELS.size
        fail SerializationError, "unexpected identifier field: #{parts[ALLOWED_LABELS.size]}"
      end

      schema = fields["sch"].match(/\A(?<id>[a-z0-9]{16})@(?<version>\d+)\z/)
      fail SerializationError, "bad schema identifier: #{fields['sch'].inspect}" unless schema

      new(
        uuid:           fields["uuid"],
        schema_id:      schema[:id],
        schema_version: Integer(schema[:version], 10),
        key_id:         fields["kid"],
        issued_at:      Time.iso8601(fields["iat"])
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
