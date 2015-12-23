# Support for opaque binary data
class Boulangerie::Type::Binary < Boulangerie::Type
  register "Binary", new(allowed_classes: String)

  def serialize(string)
    unless string.encoding == Encoding::BINARY
      fail Boulangerie::SerializationError, "bad string encoding: #{string.encoding}"
    end

    string
  end

  def deserialize(string)
    unless string.encoding == Encoding::BINARY
      fail Boulangerie::SerializationError, "bad string encoding: #{string.encoding}"
    end

    string
  end
end
