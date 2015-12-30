# Integer values serialized as base 10
class Boulangerie::Type::Decimal < Boulangerie::Type
  register "Decimal", new(allowed_classes: [Fixnum, String]), list_allowed: true

  def serialize(value)
    case value
    when Fixnum then value.to_s
    when String then value if deserialize(value)
    end
  end

  def deserialize(string)
    Integer(string, 10)
  end
end
