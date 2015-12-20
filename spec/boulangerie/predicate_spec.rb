RSpec.describe Boulangerie::Predicate do
  let(:example_type)      { "Boolean" }
  let(:example_predicate) { described_class.new(example_type) }

  it "serializes" do
    expect(example_predicate.serialize(true)).to eq "true"
  end
end
