class Boulangerie
  # Static types for schemas and serialized data
  class Type
    @@types = {}

    attr_accessor :type_name
    attr_reader :allowed_classes

    def self.register(type_name, obj)
      fail ArgumentError, "duplicate type name: #{type_name}" if @@types.key?(type_name)
      fail TypeError, "#{obj} not a #{self} subclass" unless obj.is_a?(self)

      obj.type_name = type_name
      @@types[type_name.freeze] = obj.freeze
    end

    def self.[](type_name)
      @@types[type_name] || fail(TypeError, "invalid Boulangerie::Type: #{type_name.inspect}")
    end

    def initialize(allowed_classes: [])
      @allowed_classes = Array(allowed_classes)
    end
  end
end
