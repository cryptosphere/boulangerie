RSpec.describe Boulangerie::Macaroon do
  let(:example_key)      { "BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA55BADA" }
  let(:example_location) { "https://mysupercoolsite.com" }

  let(:example_schema) do
    Boulangerie::Schema.from_yaml(fixture_path.join("example_schema.yml").read)
  end

  let(:example_identifier) do
    Boulangerie::Identifier.new(
      schema_id:      example_schema.schema_id,
      schema_version: example_schema.current_version,
      key_id:         "k1"
    )
  end

  subject do
    described_class.new(
      key:        example_key,
      location:   example_location,
      identifier: example_identifier
    )
  end

  describe "::from_binary" do
    it "parses macaroons" do
      macaroon = described_class.from_binary(subject.serialize)
      expect(macaroon).to be_a described_class
    end
  end

  describe "#serialize" do
    it "serializes" do
      expect(subject.serialize).to be_a String
    end
  end

  describe "#inspect" do
    it "does not include keys in #inspect" do
      expect(subject.inspect).to_not include(example_key)
    end
  end
end
