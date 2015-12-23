require "time"

# Support for ISO8601 dates
class Boulangerie::Type::DateTime < Boulangerie::Type
  register "DateTime", new(allowed_classes: Time)

  def serialize(datetime)
    datetime.iso8601
  end

  def deserialize(string)
    Time.iso8601(string)
  end
end
