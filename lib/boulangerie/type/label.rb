# Constrained strings useful for representing a wide variety of formats
class Boulangerie::Type::Label < Boulangerie::Type
  # All valid labels must match this regex
  LABEL_REGEX = %r{\A[0-9a-zA-Z\.\/\-_]+\z}

  register "Label", new(allowed_classes: [String, Symbol]), list_allowed: true

  def serialize(value)
    value = value.to_s
    fail Boulangerie::SerializationError, "bad characters: #{value}" unless value[LABEL_REGEX]
    value
  end

  def deserialize(string)
    fail Boulangerie::SerializationError, "bad characters: #{string}" unless string[LABEL_REGEX]
    string
  end
end
