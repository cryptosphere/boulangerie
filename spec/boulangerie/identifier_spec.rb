RSpec.describe Boulangerie::Identifier do
  let(:example_schema) do
    Boulangerie::Schema.from_yaml(fixture_path.join("example_schema.yml").read)
  end

  let(:example_schema_id)      { example_schema.schema_id }
  let(:example_schema_version) { example_schema.current_version }
  let(:example_key_id)         { "k1" }

  let(:example_identifier) do
    described_class.new(
      schema_id:      example_schema_id,
      schema_version: example_schema_version,
      key_id:         example_key_id
    )
  end

  describe "::parse" do
    it "parses serialized identifiers" do
      identifier = described_class.parse(example_identifier.to_str)

      expect(identifier.schema_id).to eq example_schema_id
      expect(identifier.schema_version).to eq example_schema_version
      expect(identifier.key_id).to eq example_key_id
    end
  end

  describe "#to_str" do
    it "serializes identifiers as strings" do
      expect(example_identifier.to_str).to be_a(String)
    end
  end
end
