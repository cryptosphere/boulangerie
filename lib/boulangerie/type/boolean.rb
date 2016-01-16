# frozen_string_literal: true
# Support for 'true' and 'false'
class Boulangerie::Type::Boolean < Boulangerie::Type
  register "Boolean", new(allowed_classes: [TrueClass, FalseClass, NilClass]), list_allowed: true

  def serialize(value)
    value == true ? "true".freeze : "false".freeze
  end

  def deserialize(string)
    case string
    when "true".freeze  then true
    when "false".freeze then false
    else fail Boulangerie::SerializationError, "expecting true/false value: #{string.inspect}"
    end
  end
end
