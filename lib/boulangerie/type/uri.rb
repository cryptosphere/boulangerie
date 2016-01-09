# Constrained strings useful for representing a wide variety of formats
class Boulangerie::Type::URI < Boulangerie::Type
  register "URI", new(allowed_classes: [String, URI]), list_allowed: true

  def serialize(value)
    URI(value).to_s
  end

  def deserialize(string)
    URI(string)
  end
end
