class Boulangerie
  # Static types for schemas and serialized data
  class Type
    REGISTRY = {}

    attr_accessor :type_name
    attr_reader :allowed_classes

    def self.register(type_name, obj, list_allowed: false)
      fail ArgumentError, "duplicate type name: #{type_name}" if REGISTRY.key?(type_name)
      fail TypeError, "#{obj} not a #{self} subclass" unless obj.is_a?(self)

      obj.type_name = type_name
      REGISTRY[type_name.freeze] = obj.freeze

      List.register "List(#{type_name})", List.new(list_type: obj) if list_allowed
    end

    def self.[](type_name)
      REGISTRY[type_name] || fail(TypeError, "invalid Boulangerie::Type: #{type_name.inspect}")
    end

    def initialize(allowed_classes: [])
      @allowed_classes = Array(allowed_classes)
    end
  end
end
