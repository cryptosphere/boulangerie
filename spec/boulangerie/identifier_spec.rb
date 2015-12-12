RSpec.describe Boulangerie::Identifier do
  let(:example_schema) do
    Boulangerie::Schema.from_yaml(fixture_path.join("example_schema.yml").read)
  end

  let(:example_identifier) do
    described_class.new(
      schema: example_schema,
      key_id: "k1"
    )
  end

  it "serializes identifiers as strings" do
    expect(example_identifier.to_str).to be_a(String)
  end
end
