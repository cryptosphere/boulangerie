RSpec.describe Boulangerie::Type::List do
  let(:example_type)   { "Boolean" }
  let(:example_array)  { [true, false, true] }
  let(:example_output) { example_array.join(" ") }

  subject { described_class.new(list_type: Boulangerie::Type[example_type]) }

  describe "#serialize" do
    it "serializes" do
      expect(subject.serialize(example_array)).to eq example_output
    end
  end

  describe "#deserialize" do
    it "deserializes" do
      expect(subject.deserialize(example_output)).to eq example_array
    end
  end
end
