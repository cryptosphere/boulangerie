RSpec.describe Boulangerie::Predicate do
  let(:example_type)      { "Boolean" }
  let(:example_predicate) { described_class.new(example_type) }

  let(:example_deserialized) { true }
  let(:example_serialized)   { "true" }

  it "serializes" do
    expect(example_predicate.serialize(example_deserialized)).to eq example_serialized
  end

  it "deserializes" do
    expect(example_predicate.deserialize(example_serialized)).to eq example_deserialized
  end
end
