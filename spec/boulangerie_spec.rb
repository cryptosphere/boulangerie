RSpec.describe Boulangerie do
  let(:example_key_id) { "key1" }

  let(:example_keys) do
    { example_key_id => "totally secret key I swear" }
  end

  it "raises NotConfiguredError unless configured" do
    expect { described_class.default }.to raise_error(described_class::NotConfiguredError)
  end

  it "initializes a default Boulangerie" do
    boulangerie = described_class.new(
      schema: fixture_path.join("example_schema.yml"),
      keys:   example_keys,
      key_id: example_key_id
    )

    expect(boulangerie).to be_a described_class
  end

  it "initializes from a Schema class instead of a path" do
    boulangerie = described_class.new(
      schema: Boulangerie::Schema.from_yaml(fixture_path.join("example_schema.yml").read),
      keys:   example_keys,
      key_id: example_key_id
    )

    expect(boulangerie).to be_a described_class
  end
end
