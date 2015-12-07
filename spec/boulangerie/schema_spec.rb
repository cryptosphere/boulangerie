RSpec.describe Boulangerie::Schema do
  let(:example_schema_file) { fixture_path + "example_schema.yml" }
  let(:example_schema_id)   { "ee6da70e5ba01fec" }

  it "generates random schema-ids" do
    expect(described_class.create_schema_id).to match(/\h{16}/)
  end

  it "loads schemas from YAML files" do
    schema = described_class.from_yaml(example_schema_file.read)

    expect(schema.schema_id).to eq example_schema_id
    expect(schema.versions.size).to eq 1
  end

  it "rejects schemas without a schema-id"

  it "rejects non-sequential version numbers"

  it "rejects schemas with bad types"
end
