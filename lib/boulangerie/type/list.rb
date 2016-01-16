# frozen_string_literal: true
# Support for lists of other types
class Boulangerie::Type::List < Boulangerie::Type
  # Character to use for delimiting elements of a list
  DELIMITER = " ".freeze

  def initialize(allowed_classes: [Array], list_type: nil)
    super(allowed_classes: allowed_classes)

    @list_type = list_type
  end

  def serialize(array)
    array.map do |value|
      @list_type.typecheck(value)
      @list_type.serialize(value)
    end.join(DELIMITER)
  end

  def deserialize(string)
    string.split(DELIMITER).map { |element| @list_type.deserialize(element) }
  end
end
