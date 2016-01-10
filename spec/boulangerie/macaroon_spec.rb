RSpec.describe Boulangerie::Macaroon do
  let(:example_key)      { "BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA" }
  let(:example_location) { "https://mysupercoolsite.com" }

  let(:example_schema) do
    Boulangerie::Schema.from_yaml(fixture_path.join("example_schema.yml").read)
  end

  let(:example_identifier) do
    Boulangerie::Identifier.new(
      schema: example_schema,
      key_id: "k1"
    )
  end

  subject do
    described_class.new(
      key:        example_key,
      location:   example_location,
      identifier: example_identifier
    )
  end

  it "serializes" do
    expect(subject.serialize).to be_a String
  end
end
