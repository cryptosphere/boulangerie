RSpec.describe Boulangerie::Type::Decimal do
  let(:example_decimal)    { 42 }
  let(:example_serialized) { example_decimal.to_s }

  describe "#serialize" do
    it "serializes Fixnum objects" do
      serialized = subject.serialize(example_decimal)
      expect(serialized).to eq example_serialized
    end

    it "serializes decimal values from String" do
      serialized = subject.serialize(example_serialized)
      expect(serialized).to eq example_serialized
    end

    it "raises ArgumentError if string is not a decimal value" do
      expect { subject.serialize("bogus") }.to raise_error ArgumentError
    end
  end

  describe "#deserialize" do
    it "deserializes" do
      deserialized = subject.deserialize(example_serialized)
      expect(deserialized).to eq example_decimal
    end
  end
end
